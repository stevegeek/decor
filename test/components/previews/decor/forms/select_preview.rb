# Select component for displaying a dropdown list of options for user selection
# @label Select
class ::Decor::Forms::SelectPreview < ::Lookbook::Preview
  # @group Examples

  # Basic select with options
  def default
    render ::Decor::Forms::Select.new(
      name: "select_default",
      label: "Choose an option",
      **::Decor::Forms::Select.map_options_for_select([
        {title: "Option 1", value: "1"},
        {title: "Option 2", value: "2"},
        {title: "Option 3", value: "3"}
      ])
    )
  end

  # Select with placeholder and helper text
  def with_placeholder
    render ::Decor::Forms::Select.new(
      name: "select_placeholder",
      label: "Select a country",
      placeholder: "Choose a country...",
      helper_text: "Select your country of residence",
      **::Decor::Forms::Select.map_options_for_select([
        {title: "United States", value: "us"},
        {title: "Canada", value: "ca"},
        {title: "Mexico", value: "mx"},
        {title: "United Kingdom", value: "uk"}
      ])
    )
  end

  # Select with grouped options
  def grouped_options
    render ::Decor::Forms::Select.new(
      name: "select_grouped",
      label: "Select a product",
      helper_text: "Products organized by category",
      **::Decor::Forms::Select.map_grouped_options_for_select([
        {
          title: "Electronics",
          value: [
            {title: "Laptop", value: "laptop"},
            {title: "Phone", value: "phone"},
            {title: "Tablet", value: "tablet"}
          ]
        },
        {
          title: "Accessories",
          value: [
            {title: "Headphones", value: "headphones"},
            {title: "Charger", value: "charger"},
            {title: "Case", value: "case"}
          ]
        }
      ])
    )
  end

  # Select in a form context
  def in_form
    klass = Class.new(TypedForm) do
      def self.name
        "SelectForm"
      end
      prop :country, String
    end

    model = klass.new(country: "us")

    render_with_template(
      template: "decor/forms/select_preview/in_form",
      locals: {
        model: model,
        options: ::Decor::Forms::Select.map_options_for_select([
          {title: "United States", value: "us", selected: true},
          {title: "Canada", value: "ca"},
          {title: "Mexico", value: "mx"},
          {title: "United Kingdom", value: "uk"}
        ]),
        stacked_form: true,
        label: "Country",
        description: "Select your country",
        show_label: true,
        required: true,
        helper_text: "Required for shipping"
      }
    )
  end

  # @group Playground
  # @param label text
  # @param description text
  # @param placeholder text
  # @param helper_text text
  # @param required toggle
  # @param disabled toggle
  # @param compact toggle
  # @param include_blank_option toggle
  # @param disable_blank_option toggle
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  # @param label_position [Symbol] select [~, top, left, right, inline, inside]
  # @param grid_span [Symbol] select [~, span_1, span_2, span_half, span_4, span_5, span_full]
  # @param floating_error_text toggle
  # @param selected_option select [~, "1", "2", "3", "4"]
  def playground(
    label: "Select an option",
    description: nil,
    placeholder: nil,
    helper_text: nil,
    required: false,
    disabled: false,
    compact: false,
    include_blank_option: false,
    disable_blank_option: true,
    size: nil,
    color: nil,
    style: nil,
    label_position: :top,
    grid_span: nil,
    floating_error_text: false,
    selected_option: nil
  )
    render ::Decor::Forms::Select.new(
      name: "select_playground",
      label: label,
      description: description,
      placeholder: placeholder,
      helper_text: helper_text,
      required: required,
      disabled: disabled,
      compact: compact,
      include_blank_option: include_blank_option,
      disable_blank_option: disable_blank_option,
      size: size,
      color: color,
      style: style,
      label_position: label_position,
      grid_span: grid_span,
      floating_error_text: floating_error_text,
      **::Decor::Forms::Select.map_options_for_select([
        {title: "Option 1", value: "1"},
        {title: "Option 2", value: "2"},
        {title: "Option 3 (disabled)", value: "3", disabled: true},
        {title: "Option 4", value: "4", selected: selected_option == "4"}
      ])
    )
  end

  # @group States

  # Required field
  def required
    render ::Decor::Forms::Select.new(
      name: "select_required",
      label: "Department",
      required: true,
      helper_text: "Please select your department",
      **::Decor::Forms::Select.map_options_for_select([
        {title: "Engineering", value: "eng"},
        {title: "Design", value: "design"},
        {title: "Marketing", value: "marketing"},
        {title: "Sales", value: "sales"}
      ])
    )
  end

  # Disabled state
  def disabled
    render ::Decor::Forms::Select.new(
      name: "select_disabled",
      label: "Disabled select",
      disabled: true,
      helper_text: "This field is disabled",
      **::Decor::Forms::Select.map_options_for_select([
        {title: "Option 1", value: "1", selected: true},
        {title: "Option 2", value: "2"}
      ])
    )
  end

  # Error state
  def with_error
    render ::Decor::Forms::Select.new(
      name: "select_error",
      label: "Priority level",
      error_messages: ["Please select a valid priority level"],
      **::Decor::Forms::Select.map_options_for_select([
        {title: "Low", value: "low"},
        {title: "Medium", value: "medium"},
        {title: "High", value: "high"},
        {title: "Critical", value: "critical"}
      ])
    )
  end

  # @group Features

  # Select with disabled options
  def with_disabled_options
    render ::Decor::Forms::Select.new(
      name: "select_disabled_opts",
      label: "Available time slots",
      helper_text: "Unavailable slots are disabled",
      **::Decor::Forms::Select.map_options_for_select([
        {title: "9:00 AM - 10:00 AM", value: "9am"},
        {title: "10:00 AM - 11:00 AM (Booked)", value: "10am", disabled: true},
        {title: "11:00 AM - 12:00 PM", value: "11am"},
        {title: "12:00 PM - 1:00 PM (Lunch)", value: "12pm", disabled: true},
        {title: "1:00 PM - 2:00 PM", value: "1pm"},
        {title: "2:00 PM - 3:00 PM (Booked)", value: "2pm", disabled: true},
        {title: "3:00 PM - 4:00 PM", value: "3pm"}
      ])
    )
  end

  # Select with blank option
  def with_blank_option
    render ::Decor::Forms::Select.new(
      name: "select_blank",
      label: "Optional selection",
      include_blank_option: true,
      disable_blank_option: false,
      helper_text: "You can leave this field empty",
      **::Decor::Forms::Select.map_options_for_select([
        {title: "Option A", value: "a"},
        {title: "Option B", value: "b"},
        {title: "Option C", value: "c"}
      ])
    )
  end

  # @group Sizes

  # All size variations
  def sizes
    render_with_template(
      template: "decor/forms/select_preview/sizes"
    )
  end

  # @group Colors

  # All color variations
  def colors
    render_with_template(
      template: "decor/forms/select_preview/colors"
    )
  end

  # @group Styles

  # All style variations
  def styles
    render_with_template(
      template: "decor/forms/select_preview/styles"
    )
  end

  # @group Label Positions

  # All label position variations
  def label_positions
    render_with_template(
      template: "decor/forms/select_preview/label_positions"
    )
  end
end
