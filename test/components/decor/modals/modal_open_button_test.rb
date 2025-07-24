require "test_helper"

class Decor::Modals::ModalOpenButtonTest < ActiveSupport::TestCase
  test "renders successfully with required modal_id" do
    component = Decor::Modals::ModalOpenButton.new(modal_id: "test-modal")
    rendered = render_component(component)

    assert_includes rendered, "decor--modals--modal-open-button"
    assert_includes rendered, "btn"
  end

  test "inherits from Button component" do
    component = Decor::Modals::ModalOpenButton.new(modal_id: "modal-1")

    assert component.is_a?(Decor::Button)
  end

  test "renders with modal-opening data attributes" do
    component = Decor::Modals::ModalOpenButton.new(modal_id: "my-modal")
    rendered = render_component(component)

    # Should have data attributes for opening modal
    assert_includes rendered, 'data-action="click->decor--modals--modal-open-button#handleButtonClick"'
  end

  test "renders with correct modal controller" do
    component = Decor::Modals::ModalOpenButton.new(modal_id: "target-modal")
    rendered = render_component(component)

    assert_includes rendered, "decor--modals--modal-open-button"
  end

  test "supports button label" do
    component = Decor::Modals::ModalOpenButton.new(modal_id: "text-modal", label: "Open Modal")
    rendered = render_component(component)

    assert_includes rendered, "Open Modal"
  end

  test "supports button styling options" do
    component = Decor::Modals::ModalOpenButton.new(
      modal_id: "styled-modal",
      style: :filled,
      color: :primary,
      size: :lg
    )
    rendered = render_component(component)

    assert_includes rendered, "btn"
    assert_includes rendered, "btn-primary"
    assert_includes rendered, "btn-lg"
  end

  test "handles modal_id as required attribute" do
    component = Decor::Modals::ModalOpenButton.new(modal_id: "required-modal")

    assert_equal "required-modal", component.modal_id
  end

  test "renders as button element" do
    component = Decor::Modals::ModalOpenButton.new(modal_id: "button-modal")
    fragment = render_fragment(component)

    button = fragment.at_css("button")
    assert_not_nil button
    assert_includes button["class"], "btn"
  end

  test "component passes through Button attributes" do
    component = Decor::Modals::ModalOpenButton.new(
      modal_id: "passthrough-modal",
      disabled: true,
      type: "button"
    )
    rendered = render_component(component)

    assert_includes rendered, "disabled"
    assert_includes rendered, 'type="button"'
  end

  test "supports custom CSS classes" do
    component = Decor::Modals::ModalOpenButton.new(
      modal_id: "custom-modal",
      classes: "custom-button-class"
    )
    rendered = render_component(component)

    assert_includes rendered, "custom-button-class"
    assert_includes rendered, "btn"
  end

  test "renders with Stimulus data attributes for modal interaction" do
    component = Decor::Modals::ModalOpenButton.new(modal_id: "stimulus-modal")
    fragment = render_fragment(component)

    button = fragment.at_css("button")
    assert_not_nil button

    # Should have data attributes for Stimulus controller interaction
    data_action = button["data-action"]
    assert_not_nil data_action
    assert_includes data_action, "decor--modals--modal-open-button"
  end

  test "handles various modal ID formats" do
    test_ids = ["modal-1", "my_modal", "userSettingsModal"]

    test_ids.each do |modal_id|
      component = Decor::Modals::ModalOpenButton.new(modal_id: modal_id)
      rendered = render_component(component)

      assert_includes rendered, "decor--modals--modal-open-button"
      assert_includes rendered, "btn"
    end
  end
end
