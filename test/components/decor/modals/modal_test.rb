require "test_helper"

class Decor::Modals::ModalTest < ActiveSupport::TestCase
  test "renders successfully with default attributes" do
    component = Decor::Modals::Modal.new(id: "test-modal")
    rendered = render_component(component)

    assert_includes rendered, "test-modal"
    assert_includes rendered, "decor--modals--modal"
  end

  test "renders with component classes" do
    component = Decor::Modals::Modal.new(id: "modal-1")
    rendered = render_component(component)

    assert_includes rendered, "decor--modals--modal"
    assert_includes rendered, "modal"
  end

  test "renders with Stimulus controller" do
    component = Decor::Modals::Modal.new(id: "stimulus-modal")
    rendered = render_component(component)

    assert_includes rendered, 'data-controller="decor--modals--modal"'
  end

  test "renders with correct modal structure" do
    component = Decor::Modals::Modal.new(id: "structured-modal")
    fragment = render_fragment(component)

    modal_dialog = fragment.at_css("dialog")
    assert_not_nil modal_dialog
    assert_equal "structured-modal", modal_dialog["id"]
    assert_includes modal_dialog["class"], "decor--modals--modal"
  end

  test "renders with backdrop" do
    component = Decor::Modals::Modal.new(id: "backdrop-modal")
    fragment = render_fragment(component)

    backdrop = fragment.at_css("form[data-decor--modals--modal-target='overlay']")
    assert_not_nil backdrop
    assert_includes backdrop["class"], "modal-backdrop"
  end

  test "renders modal content container" do
    component = Decor::Modals::Modal.new(id: "box-modal")
    fragment = render_fragment(component)

    modal_content = fragment.at_css("div[data-decor--modals--modal-target='modal']")
    assert_not_nil modal_content
    assert_includes modal_content["class"], "modal-box"
  end

  test "supports initial content" do
    component = Decor::Modals::Modal.new(id: "content-modal", initial_content: "Modal content here")
    rendered = render_component(component)

    assert_includes rendered, "Modal content here"
  end

  test "handles id attribute requirement" do
    component = Decor::Modals::Modal.new(id: "required-id")

    assert_equal "required-id", component.id
  end

  test "component inherits from PhlexComponent" do
    component = Decor::Modals::Modal.new(id: "inheritance-test")

    assert component.is_a?(Decor::PhlexComponent)
  end

  test "renders with CSS classes for styling" do
    component = Decor::Modals::Modal.new(id: "styled-modal")
    rendered = render_component(component)

    assert_includes rendered, "decor--modals--modal"
    assert_includes rendered, "modal"
  end

  test "modal backdrop has correct data attributes" do
    component = Decor::Modals::Modal.new(id: "data-modal")
    fragment = render_fragment(component)

    backdrop = fragment.at_css("form[data-decor--modals--modal-target='overlay']")
    assert_not_nil backdrop
    # Backdrop typically has data attributes for closing modal
    assert_includes backdrop["data-action"], "overlayClicked"
  end

  test "renders empty modal when no content provided" do
    component = Decor::Modals::Modal.new(id: "empty-modal")
    rendered = render_component(component)

    assert_includes rendered, "decor--spinner"
    # Should still have the structure even without content
    assert_includes rendered, "empty-modal"
  end
end
