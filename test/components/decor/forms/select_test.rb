require "test_helper"

class Decor::Forms::SelectTest < ActiveSupport::TestCase
  test "renders successfully with valid attributes" do
    component = Decor::Forms::Select.new(
      name: "category",
      label: "Select Category",
      options_array: [["Option 1", "1"], ["Option 2", "2"]]
    )
    rendered = render_component(component)

    assert_includes rendered, "Select Category"
    assert_includes rendered, 'name="category"'
    assert_includes rendered, "Option 1"
    assert_includes rendered, "Option 2"
  end

  test "renders with DaisyUI select classes by default" do
    component = Decor::Forms::Select.new(
      name: "category",
      label: "Select Category",
      options_array: [["Option 1", "1"]]
    )
    fragment = render_fragment(component)

    select_element = fragment.at_css("select")
    assert_not_nil select_element
    assert_includes select_element["class"], "select"
    assert_includes select_element["class"], "w-full"
  end

  test "applies color attribute correctly" do
    component = Decor::Forms::Select.new(
      name: "category",
      label: "Select Category",
      options_array: [["Option 1", "1"]],
      color: :secondary
    )
    fragment = render_fragment(component)

    select_element = fragment.at_css("select")
    assert_includes select_element["class"], "select-secondary"
  end

  test "applies size attribute correctly" do
    component = Decor::Forms::Select.new(
      name: "category",
      label: "Select Category",
      options_array: [["Option 1", "1"]],
      size: :lg
    )
    fragment = render_fragment(component)

    select_element = fragment.at_css("select")
    assert_includes select_element["class"], "select-lg"
  end

  test "applies error styling when errors present" do
    component = Decor::Forms::Select.new(
      name: "category",
      label: "Select Category",
      options_array: [["Option 1", "1"]],
      error_messages: ["Please select a category"]
    )
    fragment = render_fragment(component)

    select_element = fragment.at_css("select")
    assert_includes select_element["class"], "select-error"
  end

  test "renders with correct name attribute" do
    component = Decor::Forms::Select.new(
      name: "category",
      label: "Select Category",
      options_array: [["Option 1", "1"]]
    )
    fragment = render_fragment(component)

    select_element = fragment.at_css("select")
    assert_not_nil select_element
    assert_equal "category", select_element["name"]
  end

  test "supports disabled state" do
    component = Decor::Forms::Select.new(
      name: "category",
      label: "Select Category",
      options_array: [["Option 1", "1"]],
      disabled: true
    )
    fragment = render_fragment(component)

    select_element = fragment.at_css("select")
    assert select_element.has_attribute?("disabled")
  end

  test "supports required attribute" do
    component = Decor::Forms::Select.new(
      name: "category",
      label: "Select Category",
      options_array: [["Option 1", "1"]],
      required: true
    )
    fragment = render_fragment(component)

    select_element = fragment.at_css("select")
    assert select_element.has_attribute?("required")
  end

  test "renders helper text when provided" do
    component = Decor::Forms::Select.new(
      name: "category",
      label: "Select Category",
      options_array: [["Option 1", "1"]],
      helper_text: "Choose your preferred category"
    )
    rendered = render_component(component)

    assert_includes rendered, "Choose your preferred category"
  end

  test "renders options with correct values and text" do
    options = [["First Option", "first"], ["Second Option", "second"]]
    component = Decor::Forms::Select.new(
      name: "category",
      label: "Select Category",
      options_array: options
    )
    fragment = render_fragment(component)

    option_elements = fragment.css("option")
    assert_equal "First Option", option_elements[0].text
    assert_equal "first", option_elements[0]["value"]
    assert_equal "Second Option", option_elements[1].text
    assert_equal "second", option_elements[1]["value"]
  end

  test "renders selected option correctly" do
    component = Decor::Forms::Select.new(
      name: "category",
      label: "Select Category",
      options_array: [["Option 1", "1"], ["Option 2", "2"]],
      selected_option: "2"
    )
    fragment = render_fragment(component)

    selected_option = fragment.at_css("option[selected]")
    assert_not_nil selected_option
    assert_equal "2", selected_option["value"]
  end

  test "supports grouped options" do
    grouped_options = [
      ["Group 1", [["Option 1A", "1a"], ["Option 1B", "1b"]]],
      ["Group 2", [["Option 2A", "2a"], ["Option 2B", "2b"]]]
    ]
    component = Decor::Forms::Select.new(
      name: "category",
      label: "Select Category",
      options_array: grouped_options
    )
    fragment = render_fragment(component)

    optgroups = fragment.css("optgroup")
    assert_equal 2, optgroups.length
    assert_equal "Group 1", optgroups[0]["label"]
    assert_equal "Group 2", optgroups[1]["label"]
  end

  test "includes blank option when requested" do
    component = Decor::Forms::Select.new(
      name: "category",
      label: "Select Category",
      options_array: [["Option 1", "1"]],
      include_blank_option: true
    )
    fragment = render_fragment(component)

    first_option = fragment.css("option").first
    assert_equal "", first_option["value"]
  end

  test "supports placeholder option" do
    component = Decor::Forms::Select.new(
      name: "category",
      label: "Select Category",
      options_array: [["Option 1", "1"]],
      placeholder: "Choose an option..."
    )
    fragment = render_fragment(component)

    first_option = fragment.css("option").first
    assert_equal "Choose an option...", first_option.text
    assert_equal "", first_option["value"]
  end

  test "component inherits from FormField" do
    component = Decor::Forms::Select.new(
      name: "category",
      label: "Select Category",
      options_array: [["Option 1", "1"]]
    )

    assert component.is_a?(Decor::Forms::FormField)
  end
end
