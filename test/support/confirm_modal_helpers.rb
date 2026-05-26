# Shared helpers for system tests that interact with the decor ConfirmModal.
#
# Both the Daisy and Suite confirm modals dispatch `decor--confirm-modal:closing`
# when a button is clicked. The helpers below find whichever confirm dialog is
# currently open (either skin) by matching `[data-controller*='modals--confirm-modal'][open]`,
# then click the appropriate target button within it.
module ConfirmModalHelpers
  DAISY_CONTROLLER = "decor--daisy--modals--confirm-modal"
  SUITE_CONTROLLER = "decor--suite--modals--confirm-modal"

  # Selector that matches EITHER confirm modal when it is open.
  OPEN_MODAL_SELECTOR = "[data-controller*='modals--confirm-modal'][open]"

  # Assert the confirm modal dialog (daisy or suite) is currently open/visible.
  def assert_confirm_modal_visible(wait: 5)
    assert_selector OPEN_MODAL_SELECTOR, visible: true, wait: wait
  end

  # Click the Confirm (positive) button in whichever confirm modal is open.
  def click_confirm_positive
    assert_confirm_modal_visible
    within(OPEN_MODAL_SELECTOR) do
      # Find positive button by target attribute (works for either skin)
      find("[data-#{DAISY_CONTROLLER}-target='positiveButton'], " \
           "[data-#{SUITE_CONTROLLER}-target='positiveButton']").click
    end
  end

  # Click the Cancel (negative) button in whichever confirm modal is open.
  def click_confirm_negative
    assert_confirm_modal_visible
    within(OPEN_MODAL_SELECTOR) do
      find("[data-#{DAISY_CONTROLLER}-target='negativeButton'], " \
           "[data-#{SUITE_CONTROLLER}-target='negativeButton']").click
    end
  end
end
