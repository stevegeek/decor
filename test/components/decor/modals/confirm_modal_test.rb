require "test_helper"

class Decor::Modals::ConfirmModalTest < ActiveSupport::TestCase
  test "renders successfully with required id" do
    component = Decor::Modals::ConfirmModal.new(id: "test-confirm-modal")
    rendered = render_component(component)

    assert_includes rendered, "test-confirm-modal"
    assert_includes rendered, "decor--modals--confirm-modal"
  end

  test "inherits from Modal component" do
    component = Decor::Modals::ConfirmModal.new(id: "modal-inheritance")

    assert component.is_a?(Decor::Modals::Modal)
  end

  test "renders with confirmation dialog structure" do
    component = Decor::Modals::ConfirmModal.new(id: "confirm-structure")
    rendered = render_component(component)

    assert_includes rendered, "decor--modals--confirm-modal"
    assert_includes rendered, "Are you sure?"
  end

  test "renders default confirmation message" do
    component = Decor::Modals::ConfirmModal.new(id: "content-modal")
    rendered = render_component(component)

    assert_includes rendered, "Are you sure?"
  end

  test "renders with modal content container" do
    component = Decor::Modals::ConfirmModal.new(id: "box-confirm")
    fragment = render_fragment(component)

    modal_content = fragment.at_css("div[data-decor--modals--confirm-modal-target='modal']")
    assert_not_nil modal_content
    assert_includes modal_content["class"], "relative inline-block align-bottom bg-white rounded-lg"
  end

  test "renders with confirmation buttons" do
    component = Decor::Modals::ConfirmModal.new(id: "custom-confirm")
    rendered = render_component(component)

    assert_includes rendered, "Continue"
    assert_includes rendered, "Cancel"
    assert_includes rendered, "positiveButton"
    assert_includes rendered, "negativeButton"
  end

  test "renders with Stimulus controller" do
    component = Decor::Modals::ConfirmModal.new(id: "stimulus-confirm")
    rendered = render_component(component)

    assert_includes rendered, 'data-controller="decor--modals--confirm-modal"'
  end

  test "component inherits Modal properties" do
    component = Decor::Modals::ConfirmModal.new(id: "properties-test")

    assert_equal "properties-test", component.id
    assert component.is_a?(Decor::Modals::Modal)
    assert component.is_a?(Decor::PhlexComponent)
  end

  test "renders with confirm modal specific styling" do
    component = Decor::Modals::ConfirmModal.new(id: "styled-confirm")
    rendered = render_component(component)

    assert_includes rendered, "decor--modals--confirm-modal"
    assert_includes rendered, "fixed hidden z-10 inset-0 overflow-y-auto"
  end

  test "supports modal backdrop" do
    component = Decor::Modals::ConfirmModal.new(id: "backdrop-confirm")
    fragment = render_fragment(component)

    backdrop = fragment.at_css("div[data-decor--modals--confirm-modal-target='overlay']")
    assert_not_nil backdrop
    assert_includes backdrop["class"], "fixed hidden inset-0 bg-gray-700"
  end

  test "handles various ID formats" do
    test_ids = ["confirm-1", "deleteConfirm", "modal_confirm_123"]

    test_ids.each do |modal_id|
      component = Decor::Modals::ConfirmModal.new(id: modal_id)
      rendered = render_component(component)

      assert_includes rendered, modal_id
      assert_includes rendered, "decor--modals--confirm-modal"
    end
  end

  test "renders confirmation buttons with correct styling" do
    component = Decor::Modals::ConfirmModal.new(id: "button-confirm")
    rendered = render_component(component)

    assert_includes rendered, "btn btn-primary"
    assert_includes rendered, "btn btn-secondary"
    assert_includes rendered, "Continue"
    assert_includes rendered, "Cancel"
  end

  test "renders with default structure when no content provided" do
    component = Decor::Modals::ConfirmModal.new(id: "empty-confirm")
    rendered = render_component(component)

    # Should still render modal structure
    assert_includes rendered, "decor--modals--confirm-modal"
    assert_includes rendered, "Are you sure?"
  end
end
