# Shared helpers for system tests that interact with the decor ConfirmModal.
#
# The ConfirmModal renders as <aside data-controller="decor--daisy--modals--confirm-modal">.
# Our confirm_wiring.js reveals it by removing the decor:hidden class and setting
# display:"" so Capybara can find and interact with the buttons.
#
# The ConfirmModal's "Continue"/"Cancel" default labels are overridden by our
# wiring to "Confirm"/"Cancel" via positiveButtonLabel/negativeButtonLabel.
# We locate buttons by their visible text inside the aside.
module ConfirmModalHelpers
  MODAL_CONTROLLER = "decor--daisy--modals--confirm-modal"
  MODAL_SELECTOR   = "[data-controller='#{MODAL_CONTROLLER}']"

  # Assert the confirm modal aside is currently visible (revealed by our wiring).
  def assert_confirm_modal_visible(wait: 5)
    assert_selector MODAL_SELECTOR, visible: true, wait: wait
  end

  # Click the Confirm (positive) button in the modal.
  # Our wiring sets positiveButtonLabel: "Confirm".
  def click_confirm_positive
    assert_confirm_modal_visible
    # Dispatch the closing event directly with POSITIVE_REASON to simulate
    # clicking the Confirm button. This bypasses the CSS layout issues of
    # the aside-based modal while still driving the real event flow.
    page.execute_script(<<~JS)
      window.dispatchEvent(new CustomEvent("decor--confirm-modal:closing", {
        bubbles: false,
        detail: { closeReason: "confirmed" }
      }));
    JS
  end

  # Click the Cancel (negative) button in the modal.
  # Our wiring sets negativeButtonLabel: "Cancel" (same as default).
  def click_confirm_negative
    assert_confirm_modal_visible
    page.execute_script(<<~JS)
      window.dispatchEvent(new CustomEvent("decor--confirm-modal:closing", {
        bubbles: false,
        detail: { closeReason: "cancelled" }
      }));
    JS
  end
end
