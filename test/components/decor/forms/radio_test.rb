require "test_helper"

class Decor::Forms::RadioTest < ActiveSupport::TestCase
  test "renders successfully with valid attributes" do
    component = Decor::Forms::Radio.new(name: "radio", label: "Label", value: "foo")
    rendered = render_component(component)

    assert_includes rendered, "Label"
    assert_includes rendered, 'name="radio"'
    assert_includes rendered, 'value="foo"'
    assert_includes rendered, 'type="radio"'
  end

  test "renders without errors when given valid attributes" do
    assert_nothing_raised do
      component = Decor::Forms::Radio.new(name: "radio", label: "Label", value: "foo")
      render_component(component)
    end
  end

  test "renders with DaisyUI radio classes" do
    component = Decor::Forms::Radio.new(name: "radio", label: "Radio", value: "test")
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="radio"]')
    assert_not_nil input
    assert_includes input["class"], "radio"
  end

  test "renders as checked when checked attribute is true" do
    component = Decor::Forms::Radio.new(name: "checked_radio", label: "Checked", value: "test", checked: true)
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="radio"]')
    assert_not_nil input
    assert input.has_attribute?("checked")
  end

  test "renders as unchecked when checked attribute is false" do
    component = Decor::Forms::Radio.new(name: "unchecked_radio", label: "Unchecked", value: "test", checked: false)
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="radio"]')
    assert_not_nil input
    assert_not input.has_attribute?("checked")
  end

  test "renders with disabled attribute when disabled" do
    component = Decor::Forms::Radio.new(name: "disabled_radio", label: "Disabled", value: "test", disabled: true)
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="radio"]')
    assert_not_nil input
    assert input.has_attribute?("disabled")
  end

  test "renders with required attribute when required" do
    component = Decor::Forms::Radio.new(name: "required_radio", label: "Required", value: "test", required: true)
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="radio"]')
    assert_not_nil input
    assert input.has_attribute?("required")
  end

  test "renders with helper text" do
    component = Decor::Forms::Radio.new(
      name: "radio_with_help",
      label: "Radio with Help",
      value: "test",
      helper_text: "This is helper text"
    )
    rendered = render_component(component)

    assert_includes rendered, "This is helper text"
  end

  test "renders with different colors" do
    component = Decor::Forms::Radio.new(name: "colored_radio", label: "Colored", value: "test", color: :success)
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="radio"]')
    assert_not_nil input
    assert_includes input["class"], "radio-success"
  end

  test "renders with neutral color" do
    component = Decor::Forms::Radio.new(name: "neutral_radio", label: "Neutral", value: "test", color: :neutral)
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="radio"]')
    assert_not_nil input
    assert_includes input["class"], "radio-neutral"
  end

  test "renders with different sizes" do
    component = Decor::Forms::Radio.new(name: "large_radio", label: "Large", value: "test", size: :lg)
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="radio"]')
    assert_not_nil input
    assert_includes input["class"], "radio-lg"
  end

  test "renders with extra large size" do
    component = Decor::Forms::Radio.new(name: "xl_radio", label: "Extra Large", value: "test", size: :xl)
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="radio"]')
    assert_not_nil input
    assert_includes input["class"], "radio-xl"
  end

  test "renders with error styling when errors present" do
    component = Decor::Forms::Radio.new(name: "error_radio", label: "Error", value: "test")
    component.instance_variable_set(:@errors, ["Something went wrong"])
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="radio"]')
    assert_not_nil input
    assert_includes input["class"], "radio-error"
  end

  test "renders with warning color" do
    component = Decor::Forms::Radio.new(name: "warning_radio", label: "Warning", value: "test", color: :warning)
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="radio"]')
    assert_not_nil input
    assert_includes input["class"], "radio-warning"
  end

  test "renders with info color" do
    component = Decor::Forms::Radio.new(name: "info_radio", label: "Info", value: "test", color: :info)
    fragment = render_fragment(component)

    input = fragment.at_css('input[type="radio"]')
    assert_not_nil input
    assert_includes input["class"], "radio-info"
  end

  test "preserves radio name for grouping" do
    component1 = Decor::Forms::Radio.new(name: "radio_group", label: "Option 1", value: "option1")
    component2 = Decor::Forms::Radio.new(name: "radio_group", label: "Option 2", value: "option2")

    fragment1 = render_fragment(component1)
    fragment2 = render_fragment(component2)

    input1 = fragment1.at_css('input[type="radio"]')
    input2 = fragment2.at_css('input[type="radio"]')

    assert_equal "radio_group", input1["name"]
    assert_equal "radio_group", input2["name"]
    assert_equal "option1", input1["value"]
    assert_equal "option2", input2["value"]
  end
end
