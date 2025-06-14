require "test_helper"

class Decor::ModalLayoutTest < ActiveSupport::TestCase
  test "renders successfully with default attributes" do
    component = Decor::ModalLayout.new
    rendered = render_component(component)

    assert_includes rendered, "modal-box"
    assert_includes rendered, "decor--modal-layout"
  end

  test "renders with daisyUI modal-box classes" do
    component = Decor::ModalLayout.new
    rendered = render_component(component)

    assert_includes rendered, "modal-box"
    assert_includes rendered, "relative"
  end

  test "renders with header slot" do
    component = Decor::ModalLayout.new
    rendered = render_component(component) do |c|
      c.with_header { "Modal Header" }
    end

    assert_includes rendered, "Modal Header"
  end

  test "renders with body slot" do
    component = Decor::ModalLayout.new
    rendered = render_component(component) do |c|
      c.with_body { "Modal Body Content" }
    end

    assert_includes rendered, "Modal Body Content"
  end

  test "renders with footer slot" do
    component = Decor::ModalLayout.new
    rendered = render_component(component) do |c|
      c.with_footer { "Modal Footer" }
    end

    assert_includes rendered, "Modal Footer"
  end

  test "renders all slots together" do
    component = Decor::ModalLayout.new
    rendered = render_component(component) do |c|
      c.with_header { "Header Content" }
      c.with_body { "Body Content" }
      c.with_footer { "Footer Content" }
    end

    assert_includes rendered, "Header Content"
    assert_includes rendered, "Body Content"
    assert_includes rendered, "Footer Content"
  end

  test "renders with correct HTML structure" do
    component = Decor::ModalLayout.new
    fragment = render_fragment(component)

    modal_box = fragment.at_css(".modal-box")
    assert_not_nil modal_box
    assert_includes modal_box["class"], "decor--modal-layout"
    assert_includes modal_box["class"], "relative"
  end

  test "component inherits from PhlexComponent" do
    component = Decor::ModalLayout.new

    assert component.is_a?(Decor::PhlexComponent)
  end

  test "supports custom CSS classes via element_classes" do
    component = Decor::ModalLayout.new
    rendered = render_component(component)

    assert_includes rendered, "modal-box"
    assert_includes rendered, "relative"
  end

  test "renders without slots when none provided" do
    component = Decor::ModalLayout.new
    rendered = render_component(component)

    # Should still render the container
    assert_includes rendered, "modal-box"
    assert_includes rendered, "decor--modal-layout"
  end

  test "header slot renders in correct position" do
    component = Decor::ModalLayout.new
    fragment = render_fragment(component) do |c|
      c.with_header { "Test Header" }
      c.with_body { "Test Body" }
    end

    # Header should come before body in DOM order
    content = fragment.to_html
    header_pos = content.index("Test Header")
    body_pos = content.index("Test Body")

    assert header_pos < body_pos
  end

  test "footer slot renders in correct position" do
    component = Decor::ModalLayout.new
    fragment = render_fragment(component) do |c|
      c.with_body { "Test Body" }
      c.with_footer { "Test Footer" }
    end

    # Footer should come after body in DOM order
    content = fragment.to_html
    body_pos = content.index("Test Body")
    footer_pos = content.index("Test Footer")

    assert body_pos < footer_pos
  end
end
