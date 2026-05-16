# @label Select
class ::Decor::Suite::Forms::SelectPreview < ::Lookbook::Preview
  # @group Examples
  # @label Default
  def example_default
    render ::Decor::Suite::Forms::Select.new(
      name: "category",
      label: "Category",
      **::Decor::Suite::Forms::Select.map_options_for_select([
        {title: "Books", value: "books"},
        {title: "Music", value: "music"},
        {title: "Movies", value: "movies"}
      ])
    )
  end

  # @group Examples
  # @label With placeholder
  def example_with_placeholder
    render ::Decor::Suite::Forms::Select.new(
      name: "country",
      label: "Country",
      placeholder: "Choose a country…",
      helper_text: "Used for shipping calculations.",
      **::Decor::Suite::Forms::Select.map_options_for_select([
        {title: "United States", value: "us"},
        {title: "Canada", value: "ca"},
        {title: "Mexico", value: "mx"}
      ])
    )
  end

  # @group Examples
  # @label Grouped options
  def example_grouped
    render ::Decor::Suite::Forms::Select.new(
      name: "product",
      label: "Product",
      **::Decor::Suite::Forms::Select.map_grouped_options_for_select([
        {
          title: "Electronics",
          value: [
            {title: "Laptop", value: "laptop"},
            {title: "Phone", value: "phone"}
          ]
        },
        {
          title: "Accessories",
          value: [
            {title: "Headphones", value: "headphones"},
            {title: "Charger", value: "charger"}
          ]
        }
      ])
    )
  end

  # @group Examples
  # @label With blank option (Rails-style)
  def example_with_include_blank
    render ::Decor::Suite::Forms::Select.new(
      name: "priority",
      label: "Priority",
      include_blank: "— none —",
      disable_blank_option: false,
      **::Decor::Suite::Forms::Select.map_options_for_select([
        {title: "Low", value: "low"},
        {title: "High", value: "high"}
      ])
    )
  end

  # @group Examples
  # @label Multi-select
  def example_multiple
    render ::Decor::Suite::Forms::Select.new(
      name: "tags",
      label: "Tags",
      multiple: true,
      helper_text: "Hold ⌘/Ctrl to select multiple.",
      selected_option: ["a", "c"],
      **::Decor::Suite::Forms::Select.map_options_for_select([
        {title: "Alpha", value: "a"},
        {title: "Bravo", value: "b"},
        {title: "Charlie", value: "c"}
      ])
    )
  end

  # @group States
  # @label Disabled
  def state_disabled
    render ::Decor::Suite::Forms::Select.new(
      name: "category",
      label: "Category",
      disabled: true,
      selected_option: "books",
      **::Decor::Suite::Forms::Select.map_options_for_select([
        {title: "Books", value: "books"}
      ])
    )
  end

  # @group States
  # @label Required
  def state_required
    render ::Decor::Suite::Forms::Select.new(
      name: "department",
      label: "Department",
      required: true,
      helper_text: "Please select your department.",
      **::Decor::Suite::Forms::Select.map_options_for_select([
        {title: "Engineering", value: "eng"},
        {title: "Sales", value: "sales"}
      ])
    )
  end

  # @group States
  # @label Error
  def state_error
    render ::Decor::Suite::Forms::Select.new(
      name: "priority",
      label: "Priority",
      error_messages: ["Please select a valid priority level"],
      **::Decor::Suite::Forms::Select.map_options_for_select([
        {title: "Low", value: "low"},
        {title: "High", value: "high"}
      ])
    )
  end

  # @group Layout
  # @label Label on left
  def layout_label_left
    render ::Decor::Suite::Forms::Select.new(
      name: "category",
      label: "Category",
      label_position: :left,
      description: "Used to organise records.",
      **::Decor::Suite::Forms::Select.map_options_for_select([
        {title: "Books", value: "books"},
        {title: "Music", value: "music"}
      ])
    )
  end

  # @group Playground
  # @param label text
  # @param description text
  # @param placeholder text
  # @param helper_text text
  # @param required toggle
  # @param disabled toggle
  # @param multiple toggle
  # @param include_blank_option toggle
  # @param disable_blank_option toggle
  # @param label_position [Symbol] select [top, left]
  # @param selected_option select [~, "1", "2", "3"]
  def playground(
    label: "Choose an option",
    description: nil,
    placeholder: nil,
    helper_text: nil,
    required: false,
    disabled: false,
    multiple: false,
    include_blank_option: false,
    disable_blank_option: true,
    label_position: :top,
    selected_option: nil
  )
    render ::Decor::Suite::Forms::Select.new(
      name: "select_playground",
      label: label,
      description: description,
      placeholder: placeholder,
      helper_text: helper_text,
      required: required,
      disabled: disabled,
      multiple: multiple,
      include_blank_option: include_blank_option,
      disable_blank_option: disable_blank_option,
      label_position: label_position,
      selected_option: selected_option,
      **::Decor::Suite::Forms::Select.map_options_for_select([
        {title: "Option 1", value: "1"},
        {title: "Option 2", value: "2"},
        {title: "Option 3 (disabled)", value: "3", disabled: true}
      ])
    )
  end
end
