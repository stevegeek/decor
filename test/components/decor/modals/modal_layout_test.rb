require "test_helper"

class Decor::Modals::ModalLayoutTest < ActiveSupport::TestCase
  test "renders successfully with default attributes" do
    component = Decor::Modals::ModalLayout.new
    rendered = render_component(component)

    assert_includes rendered, "modal-box"
    assert_includes rendered, "decor--modals--modal-layout"
  end

  test "renders with daisyUI modal-box classes" do
    component = Decor::Modals::ModalLayout.new
    rendered = render_component(component)

    assert_includes rendered, "modal-box"
    assert_includes rendered, "relative"
  end

  test "renders with header slot" do
    component = Decor::Modals::ModalLayout.new
    component.with_header { "Modal Header" }
    rendered = render_component(component)

    assert_includes rendered, "Modal Header"
  end

  test "renders with body slot" do
    component = Decor::Modals::ModalLayout.new
    component.with_body { "Modal Body Content" }
    rendered = render_component(component)

    assert_includes rendered, "Modal Body Content"
  end

  test "renders with footer slot" do
    component = Decor::Modals::ModalLayout.new
    component.with_footer { "Modal Footer" }
    rendered = render_component(component)

    assert_includes rendered, "Modal Footer"
  end

  test "renders all slots together" do
    component = Decor::Modals::ModalLayout.new
    component.with_header { "Header Content" }
    component.with_body { "Body Content" }
    component.with_footer { "Footer Content" }
    rendered = render_component(component)

    assert_includes rendered, "Header Content"
    assert_includes rendered, "Body Content"
    assert_includes rendered, "Footer Content"
  end

  test "renders with correct HTML structure" do
    component = Decor::Modals::ModalLayout.new
    fragment = render_fragment(component)

    modal_box = fragment.at_css(".modal-box")
    assert_not_nil modal_box
    assert_includes modal_box["class"], "decor--modals--modal-layout"
    assert_includes modal_box["class"], "relative"
  end

  test "component inherits from PhlexComponent" do
    component = Decor::Modals::ModalLayout.new

    assert component.is_a?(Decor::PhlexComponent)
  end

  test "supports custom CSS classes via element_classes" do
    component = Decor::Modals::ModalLayout.new
    rendered = render_component(component)

    assert_includes rendered, "modal-box"
    assert_includes rendered, "relative"
  end

  test "renders without slots when none provided" do
    component = Decor::Modals::ModalLayout.new
    rendered = render_component(component)

    # Should still render the container
    assert_includes rendered, "modal-box"
    assert_includes rendered, "decor--modals--modal-layout"
  end

  test "header slot renders in correct position" do
    component = Decor::Modals::ModalLayout.new
    component.with_header { "Test Header" }
    component.with_body { "Test Body" }
    fragment = render_fragment(component)

    # Header should come before body in DOM order
    content = fragment.to_html
    header_pos = content.index("Test Header")
    body_pos = content.index("Test Body")

    assert header_pos < body_pos
  end

  test "footer slot renders in correct position" do
    component = Decor::Modals::ModalLayout.new
    component.with_body { "Test Body" }
    component.with_footer { "Test Footer" }
    fragment = render_fragment(component)

    # Footer should come after body in DOM order
    content = fragment.to_html
    body_pos = content.index("Test Body")
    footer_pos = content.index("Test Footer")

    assert body_pos < footer_pos
  end
end
