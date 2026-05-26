# Shared helpers for system tests that interact with the decor ConfirmModal.
#
# The ConfirmModal renders as a <dialog data-controller="decor--daisy--modals--confirm-modal">.
# confirm_wiring.js dispatches its open event, so the controller fills the
# labels/reasons and showModal()s it — the buttons are then real, visible, and
# clickable. Clicking Confirm/Cancel fires decor--confirm-modal:closing.
module ConfirmModalHelpers
  MODAL_CONTROLLER = "decor--daisy--modals--confirm-modal"
  MODAL_SELECTOR   = "[data-controller='#{MODAL_CONTROLLER}']"
  POS_BTN          = "[data-#{MODAL_CONTROLLER}-target='positiveButton']"
  NEG_BTN          = "[data-#{MODAL_CONTROLLER}-target='negativeButton']"

  # Assert the confirm modal dialog is currently open/visible.
  def assert_confirm_modal_visible(wait: 5)
    assert_selector "#{MODAL_SELECTOR}[open]", visible: true, wait: wait
  end

  # Click the Confirm (positive) button in the modal.
  def click_confirm_positive
    assert_confirm_modal_visible
    within(MODAL_SELECTOR) { find(POS_BTN).click }
  end

  # Click the Cancel (negative) button in the modal.
  def click_confirm_negative
    assert_confirm_modal_visible
    within(MODAL_SELECTOR) { find(NEG_BTN).click }
  end
end
