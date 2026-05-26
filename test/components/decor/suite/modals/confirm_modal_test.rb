require "test_helper"

class Decor::Suite::Modals::ConfirmModalTest < ActiveSupport::TestCase
  test "renders successfully with required id" do
    component = Decor::Suite::Modals::ConfirmModal.new(id: "test-suite-confirm-modal")
    rendered = render_component(component)

    assert_includes rendered, "test-suite-confirm-modal"
    assert_includes rendered, "decor--suite--modals--confirm-modal"
  end

  test "inherits from base ConfirmModal component" do
    component = Decor::Suite::Modals::ConfirmModal.new(id: "modal-inheritance")

    assert component.is_a?(Decor::Components::Modals::ConfirmModal)
    assert component.is_a?(Decor::Components::Modals::Modal)
    assert component.is_a?(Decor::PhlexComponent)
  end

  test "renders as a dialog element" do
    component = Decor::Suite::Modals::ConfirmModal.new(id: "dialog-confirm")
    fragment = render_fragment(component)

    dialog = fragment.at_css("dialog")
    assert_not_nil dialog
    assert_includes dialog["class"], "decor-modal"
  end

  test "renders with correct Stimulus controller" do
    component = Decor::Suite::Modals::ConfirmModal.new(id: "stimulus-confirm")
    rendered = render_component(component)

    assert_includes rendered, 'data-controller="decor--suite--modals--confirm-modal"'
  end

  test "renders with Suite modal structure and classes" do
    component = Decor::Suite::Modals::ConfirmModal.new(id: "styled-confirm")
    rendered = render_component(component)

    assert_includes rendered, "decor-modal"
    assert_includes rendered, "decor:open:flex"
    assert_includes rendered, "decor:rounded-suite-card"
    assert_includes rendered, "decor:w-[420px]"
  end

  test "renders title with default text and title target" do
    component = Decor::Suite::Modals::ConfirmModal.new(id: "title-confirm")
    rendered = render_component(component)

    assert_includes rendered, "Are you sure?"
    assert_includes rendered, "decor-modal__title"
    assert_includes rendered, "decor--suite--modals--confirm-modal-target=\"title\""
  end

  test "renders message target element" do
    component = Decor::Suite::Modals::ConfirmModal.new(id: "message-confirm")
    rendered = render_component(component)

    assert_includes rendered, "decor-modal__body"
    assert_includes rendered, "decor--suite--modals--confirm-modal-target=\"message\""
  end

  test "renders positive and negative buttons" do
    component = Decor::Suite::Modals::ConfirmModal.new(id: "button-confirm")
    rendered = render_component(component)

    assert_includes rendered, "Continue"
    assert_includes rendered, "Cancel"
    assert_includes rendered, "positiveButton"
    assert_includes rendered, "negativeButton"
  end

  test "renders positive button with primary color" do
    component = Decor::Suite::Modals::ConfirmModal.new(id: "primary-btn-confirm")
    rendered = render_component(component)

    assert_includes rendered, "decor--suite--modals--confirm-modal-target=\"positiveButton\""
    assert_includes rendered, "Continue"
  end

  test "renders negative button with outlined style" do
    component = Decor::Suite::Modals::ConfirmModal.new(id: "outlined-btn-confirm")
    fragment = render_fragment(component)

    neg_btn = fragment.at_css("[data-decor--suite--modals--confirm-modal-target='negativeButton']")
    assert_not_nil neg_btn
    assert_includes neg_btn.text.strip, "Cancel"
  end

  test "renders footer with correct structure" do
    component = Decor::Suite::Modals::ConfirmModal.new(id: "footer-confirm")
    rendered = render_component(component)

    assert_includes rendered, "decor-modal__footer"
    assert_includes rendered, "decor:justify-end"
  end

  test "renders header with correct structure" do
    component = Decor::Suite::Modals::ConfirmModal.new(id: "header-confirm")
    rendered = render_component(component)

    assert_includes rendered, "decor-modal__header"
    assert_includes rendered, "decor:border-suite-hairline"
  end

  test "renders body section with correct id" do
    component = Decor::Suite::Modals::ConfirmModal.new(id: "body-confirm")
    fragment = render_fragment(component)

    body = fragment.at_css("#body-confirm-body")
    assert_not_nil body
    assert_includes body["class"], "decor-modal__body"
  end

  test "dialog has closedby attribute" do
    component = Decor::Suite::Modals::ConfirmModal.new(id: "closedby-confirm")
    fragment = render_fragment(component)

    dialog = fragment.at_css("dialog")
    assert_equal "any", dialog["closedby"]
  end

  test "dialog has aria attributes" do
    component = Decor::Suite::Modals::ConfirmModal.new(id: "aria-confirm")
    fragment = render_fragment(component)

    dialog = fragment.at_css("dialog")
    assert_equal "aria-confirm-title", dialog["aria-labelledby"]
    assert_equal "aria-confirm-body", dialog["aria-describedby"]
  end

  test "handles various ID formats" do
    test_ids = ["confirm-1", "deleteConfirm", "suite_modal_123"]

    test_ids.each do |modal_id|
      component = Decor::Suite::Modals::ConfirmModal.new(id: modal_id)
      rendered = render_component(component)

      assert_includes rendered, modal_id
      assert_includes rendered, "decor--suite--modals--confirm-modal"
    end
  end
end
