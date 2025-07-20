# @label NumberField
class ::Decor::Forms::NumberFieldPreview < ::Lookbook::Preview
  # NumberField
  # -------
  #
  # A versatile number input field which can have text or icon prefixes and suffixes.
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
  #
  # NumberField attrs:
  # @param allow_float_input toggle
  #
  # TextField attrs:
  # @param size number
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

  # Example of a NumberField used in a form.
  #
  # @param stacked_form toggle
  #
  # Form field attrs
  # @param label text
  # @param description text
  # @param show_label toggle
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
  #
  # NumberField attrs:
  # @param allow_float_input toggle
  #
  # TextField attrs:
  # @param leading_icon_name select [~, check-circle, x, check, download, play]
  # @param trailing_icon_name select [~, check-circle, x, check, download, play]
  # @param leading_text_add_on text
  # @param trailing_text_add_on text
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
  def in_form(
    stacked_form: true,
    label: "In a form!",
    description: nil,
    show_label: true,
    compact: false,
    value: nil,
    allow_float_input: false,
    required: false,
    disabled: false,
    helper_text: nil,
    hide_label_required_asterisk: false,
    label_position: :left,
    grid_span: :span_half,
    floating_error_text: false,
    placeholder: nil,
    leading_icon_name: nil,
    trailing_icon_name: nil,
    leading_text_add_on: nil,
    trailing_text_add_on: nil,
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
        model: klass.new(count: value || 0),
        stacked_form: stacked_form,
        label: label,
        description: description,
        show_label: show_label,
        compact: compact,
        value: value,
        allow_float_input: allow_float_input,
        required: required,
        disabled: disabled,
        helper_text: helper_text,
        hide_label_required_asterisk: hide_label_required_asterisk,
        label_position: label_position,
        grid_span: grid_span,
        floating_error_text: floating_error_text,
        placeholder: placeholder,
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
      }
    )
  end
end
