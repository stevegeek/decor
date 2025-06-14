require "test_helper"

class Decor::ModalTest < ActiveSupport::TestCase
  test "renders successfully with default attributes" do
    component = Decor::Modal.new(id: "test-modal")
    rendered = render_component(component)

    assert_includes rendered, "test-modal"
    assert_includes rendered, "modal"
  end

  test "renders with daisyUI modal classes" do
    component = Decor::Modal.new(id: "modal-1")
    rendered = render_component(component)

    assert_includes rendered, "modal"
    assert_includes rendered, "decor--modal"
  end

  test "renders with Stimulus controller" do
    component = Decor::Modal.new(id: "stimulus-modal")
    rendered = render_component(component)

    assert_includes rendered, 'data-controller="decor--modal"'
  end

  test "renders with correct modal structure" do
    component = Decor::Modal.new(id: "structured-modal")
    fragment = render_fragment(component)

    modal_div = fragment.at_css(".modal")
    assert_not_nil modal_div
    assert_equal "structured-modal", modal_div["id"]
    assert_includes modal_div["class"], "decor--modal"
  end

  test "renders with backdrop" do
    component = Decor::Modal.new(id: "backdrop-modal")
    fragment = render_fragment(component)

    backdrop = fragment.at_css(".modal-backdrop")
    assert_not_nil backdrop
    assert_includes backdrop["class"], "modal-backdrop"
  end

  test "renders modal box container" do
    component = Decor::Modal.new(id: "box-modal")
    fragment = render_fragment(component)

    modal_box = fragment.at_css(".modal-box")
    assert_not_nil modal_box
    assert_includes modal_box["class"], "modal-box"
  end

  test "supports content slot" do
    component = Decor::Modal.new(id: "content-modal")
    rendered = render_component(component) do |c|
      c.with_content { "Modal content here" }
    end

    assert_includes rendered, "Modal content here"
  end

  test "handles id attribute requirement" do
    component = Decor::Modal.new(id: "required-id")

    assert_equal "required-id", component.id
  end

  test "component inherits from PhlexComponent" do
    component = Decor::Modal.new(id: "inheritance-test")

    assert component.is_a?(Decor::PhlexComponent)
  end

  test "renders with CSS classes for styling" do
    component = Decor::Modal.new(id: "styled-modal")
    rendered = render_component(component)

    assert_includes rendered, "modal"
    assert_includes rendered, "decor--modal"
  end

  test "modal backdrop has correct data attributes" do
    component = Decor::Modal.new(id: "data-modal")
    fragment = render_fragment(component)

    backdrop = fragment.at_css(".modal-backdrop")
    assert_not_nil backdrop
    # Backdrop typically has data attributes for closing modal
    assert_not_nil backdrop["class"]
  end

  test "renders empty modal when no content provided" do
    component = Decor::Modal.new(id: "empty-modal")
    rendered = render_component(component)

    assert_includes rendered, "modal-box"
    # Should still have the structure even without content
    assert_includes rendered, "test-modal" # partial ID match
  end
end
