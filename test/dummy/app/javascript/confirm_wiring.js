// confirm_wiring.js
// Wires the decor ConfirmModal to both Turbo Drive and UJS confirm flows.
//
// The ConfirmModal is a <dialog> (decor:d-modal). Dispatching its open event
// (decor--daisy--modals--confirm-modal:open) makes the controller fill the
// title/message/labels/reasons and showModal() it. Clicking Confirm/Cancel
// fires `decor--confirm-modal:closing` with { closeReason }.
//
// Import Rails directly so we mutate the same config object rails-ujs uses
// internally (Rails.confirm), regardless of import order.
import Rails from "@rails/ujs";

const CONFIRM_OPEN_EVENT = "decor--daisy--modals--confirm-modal:open";
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

// --- Turbo Drive: async Promise-based confirm ---
// Turbo calls this when a form/submitter has data-turbo-confirm="<message>".
// Resolving true proceeds with the submit; false aborts.
if (window.Turbo && window.Turbo.config && window.Turbo.config.forms) {
  window.Turbo.config.forms.confirm = function (message) {
    return new Promise(function (resolve) {
      const onClosing = function (e) {
        window.removeEventListener(CONFIRM_CLOSING_EVENT, onClosing);
        resolve(e.detail.closeReason === POSITIVE_REASON);
      };
      window.addEventListener(CONFIRM_CLOSING_EVENT, onClosing);
      window.dispatchEvent(new CustomEvent(CONFIRM_OPEN_EVENT, {
        detail: openConfirmEventDetail(message)
      }));
    });
  };
}

// --- UJS (rails-ujs): synchronous Rails.confirm with async re-trigger ---
// Rails.confirm MUST return a boolean synchronously, so we can't await the
// modal. First call: open the modal, return false (abort). On Confirm, flag the
// element and re-click it; the re-trigger sees the flag and returns true.
Rails.confirm = function (message, element) {
  if (element && element.dataset.decorConfirmed === "true") {
    delete element.dataset.decorConfirmed;
    return true;
  }
  const onClosing = function (e) {
    window.removeEventListener(CONFIRM_CLOSING_EVENT, onClosing);
    if (e.detail.closeReason === POSITIVE_REASON) {
      element.dataset.decorConfirmed = "true";
      element.click();
    }
  };
  window.addEventListener(CONFIRM_CLOSING_EVENT, onClosing);
  window.dispatchEvent(new CustomEvent(CONFIRM_OPEN_EVENT, {
    detail: openConfirmEventDetail(message)
  }));
  return false;
};
