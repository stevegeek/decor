// confirm_wiring.js
// Wires the decor ConfirmModal component to both Turbo Drive and UJS confirm flows.
//
// Event names (verified from confirm_modal_controller.js and vident component_name):
//   Open  (dispatched to window to show the modal):
//     "decor--daisy--modals--confirm-modal:open"
//   Closing (dispatched from the modal controller on positive/negative click):
//     "decor--confirm-modal:closing"  — detail: { closeReason }
//
// Note: the ConfirmModal component renders as <aside> (not <dialog>). The
// underlying modal_controller calls element.showModal() which is a no-op on
// aside in Chrome. We therefore also directly toggle the aside's visibility via
// CSS class manipulation so the buttons are reachable in the real browser.

// Import Rails directly so we always have a reference to the V (config) object,
// regardless of ES module import hoisting order or window.Rails timing.
import Rails from "@rails/ujs"

const CONFIRM_OPEN_EVENT = "decor--daisy--modals--confirm-modal:open";
const CONFIRM_CLOSING_EVENT = "decor--confirm-modal:closing";
const POSITIVE_REASON = "confirmed";
const NEGATIVE_REASON = "cancelled";
const MODAL_SELECTOR = '[data-controller="decor--daisy--modals--confirm-modal"]';
// The class that keeps the aside invisible initially.
const HIDDEN_CLASS = "decor:hidden";

function showConfirmModal() {
  const el = document.querySelector(MODAL_SELECTOR);
  if (el) {
    el.classList.remove(HIDDEN_CLASS);
    el.style.display = "";
    // Also show the overlay backdrop
    const overlay = el.querySelector('[data-decor--daisy--modals--confirm-modal-target="overlay"]');
    if (overlay) {
      overlay.classList.remove(HIDDEN_CLASS);
    }
  }
}

function hideConfirmModal() {
  const el = document.querySelector(MODAL_SELECTOR);
  if (el) {
    el.classList.add(HIDDEN_CLASS);
    el.style.display = "none";
    const overlay = el.querySelector('[data-decor--daisy--modals--confirm-modal-target="overlay"]');
    if (overlay) {
      overlay.classList.add(HIDDEN_CLASS);
    }
  }
}

// Listen for the Closing event to hide the modal (the controller's hide() also
// tries element.close() which is a no-op on aside, so we handle it ourselves).
window.addEventListener(CONFIRM_CLOSING_EVENT, function() {
  hideConfirmModal();
});

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
// Turbo calls Turbo.config.forms.confirm when a form/submitter has
// data-turbo-confirm="<message>". Returning a Promise that resolves to true
// proceeds; false aborts.
if (window.Turbo && window.Turbo.config && window.Turbo.config.forms) {
  window.Turbo.config.forms.confirm = function(message, _formElement, _submitter) {
    return new Promise(function(resolve) {
      var onClosing = function(e) {
        window.removeEventListener(CONFIRM_CLOSING_EVENT, onClosing);
        resolve(e.detail.closeReason === POSITIVE_REASON);
      };
      window.addEventListener(CONFIRM_CLOSING_EVENT, onClosing);
      window.dispatchEvent(new CustomEvent(CONFIRM_OPEN_EVENT, {
        detail: openConfirmEventDetail(message)
      }));
      showConfirmModal();
    });
  };
}

// --- UJS (rails-ujs): synchronous Rails.confirm with async re-trigger ---
// Rails.confirm MUST return a boolean synchronously, so we cannot await the
// modal. Pattern: first call returns false (abort) + shows the modal; on
// Confirm click, set a flag and re-trigger click() so rails-ujs calls
// Rails.confirm again (this time sees the flag and returns true).
//
// We import Rails directly to get the same V object reference that rails-ujs
// uses internally in its handleConfirm closure.
Rails.confirm = function(message, element) {
  // Second pass: flag set by the confirm callback — proceed and clear it.
  if (element && element.dataset.decorConfirmed === "true") {
    delete element.dataset.decorConfirmed;
    return true;
  }

  // First pass: intercept, show modal, return false to abort this submit.
  var onClosing = function(e) {
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
  showConfirmModal();
  return false;
};
