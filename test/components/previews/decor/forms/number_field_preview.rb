# @label NumberField
class ::Decor::Forms::NumberFieldPreview < ::Lookbook::Preview
  # A specialized text field for numeric input with mobile-optimized keyboards and float support.
  # Inherits all TextField features including prefixes, suffixes, and add-ons.

  # @!group Examples

  # Basic number field
  def default
    render ::Decor::Forms::NumberField.new(
      name: "age",
      label: "Age",
      placeholder: "Enter your age"
    )
  end

  # Number field with min/max constraints
  def with_constraints
    render ::Decor::Forms::NumberField.new(
      name: "quantity",
      label: "Quantity",
      min: 1,
      max: 100,
      value: "5",
      helper_text: "Choose between 1 and 100"
    )
  end

  # Number field with currency add-ons
  def currency_input
    render ::Decor::Forms::NumberField.new(
      name: "price",
      label: "Price",
      allow_float_input: true,
      leading_text_add_on: "$",
      trailing_text_add_on: "USD",
      placeholder: "0.00"
    )
  end

  # Number field in a form context
  # @param stacked_form toggle
  def in_form(stacked_form: true)
    klass = Class.new(TypedForm) do
      def self.name
        "TestClass"
      end

      prop :count, Numeric do |value|
        value.to_i
      end
    end

    render_with_template(
      locals: {
        model: klass.new(count: 42),
        stacked_form: stacked_form
      }
    )
  end

  # @!endgroup

  # @!group Playground

  # Interactive playground with all NumberField options
  #
  # Form field attrs
  # @param name text
  # @param label text
  # @param description text
  # @param compact toggle
  # @param label_position [Symbol] select [~, top, left, right, inline, inside]
  # @param grid_span [Symbol] select [~, span_1, span_2, span_half, span_4, span_5, span_full]
  # @param floating_error_text toggle
  # @param placeholder text
  # @param required toggle
  # @param hide_label_required_asterisk toggle
  # @param disabled toggle
  # @param helper_text text
  # @param value text
  # @param size [Symbol] select [~, sm, md, lg]
  # @param color [Symbol] select [~, primary, secondary, accent, success, warning, danger, info, neutral]
  # @param style [Symbol] select [~, default, minimal, ghost]
  #
  # NumberField attrs:
  # @param allow_float_input toggle
  #
  # TextField attrs:
  # @param leading_icon_name select [~, check-circle, x, check, download, play]
  # @param trailing_icon_name select [~, check-circle, x, check, download, play]
  # @param leading_text_add_on text
  # @param trailing_text_add_on text
  # @param example_leading_add_on_slot toggle
  # @param example_trailing_add_on_slot toggle
  # @param add_on_style [Symbol] select [text, boxed]
  # @param input_type [Symbol] select [text, password, email, number, tel, url, search]
  # @param pattern text
  # @param inputmode text
  # @param numerical toggle
  # @param maximum_length number
  # @param minimum_length number
  # @param validate_value_equal_to_id text
  # @param min number
  # @param max number
  # @param step number
  # @param greater_than number
  # @param less_than number
  def playground(
    name: "number-field-1",
    label: "What is your age in years?",
    description: nil,
    value: nil,
    allow_float_input: false,
    required: false,
    disabled: false,
    helper_text: nil,
    hide_label_required_asterisk: false,
    compact: false,
    label_position: :top,
    grid_span: nil,
    floating_error_text: false,
    placeholder: nil,
    size: nil,
    color: nil,
    style: nil,
    leading_icon_name: nil,
    trailing_icon_name: nil,
    leading_text_add_on: nil,
    trailing_text_add_on: nil,
    example_leading_add_on_slot: false,
    example_trailing_add_on_slot: false,
    add_on_style: :text,
    input_type: :text,
    pattern: "[0-9]*",
    inputmode: nil,
    numerical: false,
    maximum_length: nil,
    minimum_length: nil,
    validate_value_equal_to_id: nil,
    min: nil,
    max: nil,
    step: nil,
    greater_than: nil,
    less_than: nil
  )
    render ::Decor::Forms::NumberField.new(
      name: name,
      label: label,
      description: description,
      value: value,
      allow_float_input: allow_float_input,
      required: required,
      disabled: disabled,
      helper_text: helper_text,
      compact: compact,
      label_position: label_position,
      grid_span: grid_span,
      floating_error_text: floating_error_text,
      placeholder: placeholder,
      hide_required_asterisk: hide_label_required_asterisk,
      size: size,
      color: color,
      style: style,
      leading_icon_name: leading_icon_name,
      trailing_icon_name: trailing_icon_name,
      leading_text_add_on: leading_text_add_on,
      trailing_text_add_on: trailing_text_add_on,
      add_on_style: add_on_style,
      type: input_type,
      pattern: pattern,
      inputmode: inputmode,
      numerical: numerical,
      maximum_length: maximum_length,
      minimum_length: minimum_length,
      validate_value_equal_to_id: validate_value_equal_to_id,
      min: min,
      max: max,
      step: step,
      greater_than: greater_than,
      less_than: less_than
    ) do |field|
      if example_leading_add_on_slot
        field.with_leading_add_on do
          "$"
        end
      end
      if example_trailing_add_on_slot
        field.with_trailing_add_on do
          "LB"
        end
      end
    end
  end

  # @!endgroup

  # @!group Number Types

  # Integer-only input
  def integer_only
    render ::Decor::Forms::NumberField.new(
      name: "whole_numbers",
      label: "Whole numbers only",
      allow_float_input: false,
      placeholder: "123"
    )
  end

  # Float/decimal input
  def float_input
    render ::Decor::Forms::NumberField.new(
      name: "decimal",
      label: "Decimal numbers",
      allow_float_input: true,
      placeholder: "123.45",
      step: 0.01
    )
  end

  # @!endgroup

  # @!group Validation

  # With step validation
  def with_step
    render ::Decor::Forms::NumberField.new(
      name: "increments",
      label: "Increments of 5",
      step: 5,
      min: 0,
      max: 100,
      helper_text: "Must be in increments of 5"
    )
  end

  # With range validation
  def with_range
    render ::Decor::Forms::NumberField.new(
      name: "percentage",
      label: "Percentage",
      min: 0,
      max: 100,
      trailing_text_add_on: "%",
      helper_text: "Enter a value between 0 and 100"
    )
  end

  # @!endgroup

  # @!group Add-ons and Icons

  # With measurement units
  def with_units
    render ::Decor::Forms::NumberField.new(
      name: "weight",
      label: "Weight",
      trailing_text_add_on: "kg",
      allow_float_input: true
    )
  end

  # With boxed add-ons
  def with_boxed_addons
    render ::Decor::Forms::NumberField.new(
      name: "temperature",
      label: "Temperature",
      trailing_text_add_on: "°C",
      add_on_style: :boxed,
      allow_float_input: true
    )
  end

  # @!endgroup
end
