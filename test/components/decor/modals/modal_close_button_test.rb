require "test_helper"

class Decor::Modals::ModalCloseButtonTest < ActiveSupport::TestCase
  test "renders successfully as Button component" do
    component = Decor::Modals::ModalCloseButton.new
    rendered = render_component(component)

    assert_includes rendered, "btn"
    assert_includes rendered, "decor--modals--modal-close-button"
  end

  test "inherits from Button component" do
    component = Decor::Modals::ModalCloseButton.new

    assert component.is_a?(Decor::Button)
  end

  test "renders with modal-closing data attributes" do
    component = Decor::Modals::ModalCloseButton.new
    rendered = render_component(component)

    # Should have data attributes for closing modal
    assert_includes rendered, 'data-action="click->decor--modals--modal-close-button#handleButtonClick"'
  end

  test "renders with close icon by default" do
    component = Decor::Modals::ModalCloseButton.new
    rendered = render_component(component)

    # Should include close icon
    assert_includes rendered, "heroicons/outline/x-mark"
  end

  test "supports custom button styling" do
    component = Decor::Modals::ModalCloseButton.new(
      variant: :outlined,
      size: :small
    )
    rendered = render_component(component)

    assert_includes rendered, "btn-outline"
    assert_includes rendered, "btn-sm"
  end

  test "renders as button element" do
    component = Decor::Modals::ModalCloseButton.new
    fragment = render_fragment(component)

    button = fragment.at_css("button")
    assert_not_nil button
    assert_includes button["class"], "btn"
    assert_includes button["class"], "decor--modals--modal-close-button"
  end

  test "supports custom content" do
    component = Decor::Modals::ModalCloseButton.new
    rendered = render_component(component) do
      "Close"
    end

    assert_includes rendered, "Close"
  end

  test "renders with Stimulus controller data" do
    component = Decor::Modals::ModalCloseButton.new
    fragment = render_fragment(component)

    button = fragment.at_css("button")
    assert_not_nil button

    data_action = button["data-action"]
    assert_not_nil data_action
    assert_includes data_action, "decor--modals--modal-close-button#handleButtonClick"
  end

  test "supports disabled state" do
    component = Decor::Modals::ModalCloseButton.new(disabled: true)
    rendered = render_component(component)

    assert_includes rendered, "disabled"
  end

  test "applies default button styling" do
    component = Decor::Modals::ModalCloseButton.new
    rendered = render_component(component)

    assert_includes rendered, "btn"
    # Should have some default styling classes
    assert_includes rendered, "decor--modals--modal-close-button"
  end

  test "supports custom CSS classes" do
    component = Decor::Modals::ModalCloseButton.new(html_options: {class: "custom-close-btn"})
    rendered = render_component(component)

    assert_includes rendered, "custom-close-btn"
    assert_includes rendered, "btn"
  end

  test "component passes through Button attributes" do
    component = Decor::Modals::ModalCloseButton.new(
      html_options: {form: "my-form"}
    )
    rendered = render_component(component)

    assert_includes rendered, 'type="button"'
    assert_includes rendered, 'form="my-form"'
  end

  test "renders close icon with proper classes" do
    component = Decor::Modals::ModalCloseButton.new
    fragment = render_fragment(component)

    # Should have an icon element
    svg = fragment.at_css("svg")
    assert_not_nil svg
  end

  test "handles click action for modal closing" do
    component = Decor::Modals::ModalCloseButton.new
    fragment = render_fragment(component)

    button = fragment.at_css("button")
    data_action = button["data-action"]

    # Should specifically target modal close action
    assert_includes data_action, "click->decor--modals--modal-close-button#handleButtonClick"
  end
end
