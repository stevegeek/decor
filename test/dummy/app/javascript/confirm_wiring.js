// confirm_wiring.js
// Wires the decor ConfirmModal to both Turbo Drive and UJS confirm flows.
//
// Two confirm modals live in the layout:
//   - Daisy (#decor-confirm-modal): used for Daisy/Turbo Drive forms
//   - Suite (#decor-suite-confirm-modal): used for Suite/UJS forms
//
// Dispatching the open event for a modal makes its controller fill in the
// title/message/labels/reasons and showModal() it. Clicking Confirm/Cancel
// fires `decor--confirm-modal:closing` with { closeReason }.
//
// Import Rails directly so we mutate the same config object rails-ujs uses
// internally (Rails.confirm), regardless of import order.
import Rails from "@rails/ujs";

const DAISY_OPEN_EVENT  = "decor--daisy--modals--confirm-modal:open";
const SUITE_OPEN_EVENT  = "decor--suite--modals--confirm-modal:open";
const CONFIRM_CLOSING_EVENT = "decor--confirm-modal:closing";
const POSITIVE_REASON = "confirmed";
const NEGATIVE_REASON = "cancelled";

function openConfirmEventDetail(message) {
  return {
    title: "Please confirm",
    message: message,
    positiveButtonLabel: "Confirm",
    positiveButtonReason: POSITIVE_REASON,
    negativeButtonLabel: "Cancel",
    negativeButtonReason: NEGATIVE_REASON,
    defaultReason: NEGATIVE_REASON
  };
}

// Determine which open event to dispatch based on the form element's skin.
// Suite forms have data-controller containing "decor--suite--forms--form".
function openEventForElement(element) {
  if (!element) return DAISY_OPEN_EVENT;
  const form = element.closest("form") || element;
  const controller = form.dataset && form.dataset.controller || "";
  return controller.includes("decor--suite--forms--form")
    ? SUITE_OPEN_EVENT
    : DAISY_OPEN_EVENT;
}

// --- Turbo Drive: async Promise-based confirm ---
// Turbo calls this when a form/submitter has data-turbo-confirm="<message>".
// Resolving true proceeds with the submit; false aborts.
if (window.Turbo && window.Turbo.config && window.Turbo.config.forms) {
  window.Turbo.config.forms.confirm = function (message, element) {
    const openEvent = openEventForElement(element);
    return new Promise(function (resolve) {
      const onClosing = function (e) {
        window.removeEventListener(CONFIRM_CLOSING_EVENT, onClosing);
        resolve(e.detail.closeReason === POSITIVE_REASON);
      };
      window.addEventListener(CONFIRM_CLOSING_EVENT, onClosing);
      window.dispatchEvent(new CustomEvent(openEvent, {
        detail: openConfirmEventDetail(message)
      }));
    });
  };
}

// --- UJS (rails-ujs): synchronous Rails.confirm with async re-trigger ---
// Rails.confirm MUST return a boolean synchronously, so we can't await the
// modal. First call: open the modal, return false (abort). On Confirm, flag the
// element and re-click it; the re-trigger sees the flag and returns true.
// UJS confirm is always a Suite form (Suite page uses data-confirm on the submit
// button inside a decor--suite--forms--form), so always use the Suite open event.
Rails.confirm = function (message, element) {
  if (element && element.dataset.decorConfirmed === "true") {
    delete element.dataset.decorConfirmed;
    return true;
  }
  const openEvent = openEventForElement(element);
  const onClosing = function (e) {
    window.removeEventListener(CONFIRM_CLOSING_EVENT, onClosing);
    if (e.detail.closeReason === POSITIVE_REASON) {
      element.dataset.decorConfirmed = "true";
      element.click();
    }
  };
  window.addEventListener(CONFIRM_CLOSING_EVENT, onClosing);
  window.dispatchEvent(new CustomEvent(openEvent, {
    detail: openConfirmEventDetail(message)
  }));
  return false;
};
