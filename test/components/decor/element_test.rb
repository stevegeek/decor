require "test_helper"

class Decor::ElementTest < ActiveSupport::TestCase
  test "renders successfully with default options" do
    component = Decor::Element.new do
      "test content"
    end
    rendered = render_component(component)

    assert_includes rendered, "test content"
    assert_includes rendered, "<div"
  end

  test "applies custom root element attributes" do
    component = Decor::Element.new(root_element_attributes: {classes: "custom-class", id: "test-id"}) do
      "content"
    end
    rendered = render_component(component)

    assert_includes rendered, "custom-class"
    assert_includes rendered, 'id="test-id"'
    assert_includes rendered, "content"
  end

  test "handles empty root element attributes" do
    component = Decor::Element.new(root_element_attributes: {}) do
      "empty options"
    end
    rendered = render_component(component)

    assert_includes rendered, "empty options"
    assert_includes rendered, "<div"
  end

  test "renders with html options" do
    component = Decor::Element.new(root_element_attributes: {html_options: {"data-controller": "my-controller", role: "button"}}) do
      "stimulus content"
    end
    rendered = render_component(component)

    assert_includes rendered, 'data-controller="my-controller"'
    assert_includes rendered, 'role="button"'
    assert_includes rendered, "stimulus content"
  end
end