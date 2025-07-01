require "test_helper"

class Decor::Modals::ConfirmModalTest < ActiveSupport::TestCase
  test "renders successfully with required id" do
    component = Decor::Modals::ConfirmModal.new(id: "test-confirm-modal")
    rendered = render_component(component)

    assert_includes rendered, "test-confirm-modal"
    assert_includes rendered, "modal"
  end

  test "inherits from Modal component" do
    component = Decor::Modals::ConfirmModal.new(id: "modal-inheritance")

    assert component.is_a?(Decor::Modals::Modal)
  end

  test "renders with confirmation dialog structure" do
    component = Decor::Modals::ConfirmModal.new(id: "confirm-structure")
    rendered = render_component(component)

    assert_includes rendered, "modal"
    assert_includes rendered, "decor--confirm-modal"
  end

  test "supports content slot for confirmation message" do
    component = Decor::Modals::ConfirmModal.new(id: "content-modal")
    rendered = render_component(component) do |c|
      c.with_content { "Are you sure you want to delete this item?" }
    end

    assert_includes rendered, "Are you sure you want to delete this item?"
  end

  test "renders with modal-box container" do
    component = Decor::Modals::ConfirmModal.new(id: "box-confirm")
    fragment = render_fragment(component)

    modal_box = fragment.at_css(".modal-box")
    assert_not_nil modal_box
    assert_includes modal_box["class"], "modal-box"
  end

  test "supports custom confirmation content" do
    component = Decor::Modals::ConfirmModal.new(id: "custom-confirm")
    rendered = render_component(component) do |c|
      c.with_content do
        "<h3>Confirm Action</h3><p>This action cannot be undone.</p>"
      end
    end

    assert_includes rendered, "Confirm Action"
    assert_includes rendered, "This action cannot be undone."
  end

  test "renders with Stimulus controller from Modal" do
    component = Decor::Modals::ConfirmModal.new(id: "stimulus-confirm")
    rendered = render_component(component)

    assert_includes rendered, 'data-controller="decor--modal"'
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

    assert_includes rendered, "decor--confirm-modal"
    # Should also include base Modal classes
    assert_includes rendered, "modal"
  end

  test "supports modal backdrop from parent Modal" do
    component = Decor::Modals::ConfirmModal.new(id: "backdrop-confirm")
    fragment = render_fragment(component)

    backdrop = fragment.at_css(".modal-backdrop")
    assert_not_nil backdrop
    assert_includes backdrop["class"], "modal-backdrop"
  end

  test "handles various ID formats" do
    test_ids = ["confirm-1", "deleteConfirm", "modal_confirm_123", "action:confirm"]

    test_ids.each do |modal_id|
      component = Decor::Modals::ConfirmModal.new(id: modal_id)
      rendered = render_component(component)

      assert_includes rendered, modal_id
      assert_includes rendered, "modal"
    end
  end

  test "renders confirmation buttons when provided in content" do
    component = Decor::Modals::ConfirmModal.new(id: "button-confirm")
    rendered = render_component(component) do |c|
      c.with_content do
        "<p>Confirm action?</p><div class='modal-action'><button class='btn btn-error'>Delete</button><button class='btn'>Cancel</button></div>"
      end
    end

    assert_includes rendered, "btn btn-error"
    assert_includes rendered, "Delete"
    assert_includes rendered, "Cancel"
    assert_includes rendered, "modal-action"
  end

  test "renders without content when none provided" do
    component = Decor::Modals::ConfirmModal.new(id: "empty-confirm")
    rendered = render_component(component)

    # Should still render modal structure
    assert_includes rendered, "modal"
    assert_includes rendered, "modal-box"
    assert_includes rendered, "decor--confirm-modal"
  end
end
