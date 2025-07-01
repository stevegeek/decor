require "test_helper"

class Decor::Forms::SwitchTest < ActiveSupport::TestCase
  test "renders successfully with valid attributes" do
    component = Decor::Forms::Switch.new(name: "sw", label: "Switch!")
    rendered = render_component(component)

    assert_includes rendered, "Switch!"
    assert_includes rendered, 'name="sw"'
    assert_includes rendered, 'type="checkbox"'
  end

  test "renders without errors when given valid attributes" do
    assert_nothing_raised do
      component = Decor::Forms::Switch.new(name: "sw", label: "Switch!")
      render_component(component)
    end
  end

  test "renders with DaisyUI toggle classes" do
    component = Decor::Forms::Switch.new(name: "toggle", label: "Toggle")
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="checkbox"]')
    assert_not_nil input
    assert_includes input["class"], "toggle"
  end

  test "renders as checked when checked attribute is true" do
    component = Decor::Forms::Switch.new(name: "checked_switch", label: "Checked", checked: true)
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="checkbox"]')
    assert_not_nil input
    assert input.has_attribute?("checked")
  end

  test "renders as unchecked when checked attribute is false" do
    component = Decor::Forms::Switch.new(name: "unchecked_switch", label: "Unchecked", checked: false)
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="checkbox"]')
    assert_not_nil input
    assert_not input.has_attribute?("checked")
  end

  test "renders with disabled attribute when disabled" do
    component = Decor::Forms::Switch.new(name: "disabled_switch", label: "Disabled", disabled: true)
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="checkbox"]')
    assert_not_nil input
    assert input.has_attribute?("disabled")
  end

  test "renders with required attribute when required" do
    component = Decor::Forms::Switch.new(name: "required_switch", label: "Required", required: true)
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="checkbox"]')
    assert_not_nil input
    assert input.has_attribute?("required")
  end

  test "renders with helper text" do
    component = Decor::Forms::Switch.new(
      name: "switch_with_help",
      label: "Switch with Help",
      helper_text: "This is helper text"
    )
    rendered = render_component(component)

    assert_includes rendered, "This is helper text"
  end

  test "renders with different colors" do
    component = Decor::Forms::Switch.new(name: "colored_switch", label: "Colored", color: :secondary)
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="checkbox"]')
    assert_not_nil input
    assert_includes input["class"], "toggle-secondary"
  end

  test "renders with different sizes" do
    component = Decor::Forms::Switch.new(name: "large_switch", label: "Large", size: :lg)
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="checkbox"]')
    assert_not_nil input
    assert_includes input["class"], "toggle-lg"
  end

  test "renders with error styling when errors present" do
    component = Decor::Forms::Switch.new(
      name: "error_switch", 
      label: "Error",
      error_messages: ["Something went wrong"]
    )
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="checkbox"]')
    assert_not_nil input
    assert_includes input["class"], "toggle-error"
  end

  test "includes switch role attribute" do
    component = Decor::Forms::Switch.new(name: "role_switch", label: "Role")
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="checkbox"]')
    assert_not_nil input
    assert_equal "switch", input["role"]
  end
end
