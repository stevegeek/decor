# @label TextField
class ::Decor::Forms::TextFieldPreview < ::Lookbook::Preview
  # TextField
  # -------
  #
  # A DaisyUI-styled text input field with icon support and validation.
  #
  # ---------
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
  # TextField attrs:
  # @param size number
  # @param leading_icon_name select [~, user, envelope, lock, phone, search, check-circle, x, check, download, play]
  # @param trailing_icon_name select [~, user, envelope, lock, phone, search, check-circle, x, check, download, play]
  # @param leading_text_add_on text
  # @param trailing_text_add_on text
  # @param example_leading_add_on_slot toggle
  # @param example_trailing_add_on_slot toggle
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
    name: "text-field-1",
    label: "What is your name?",
    description: nil,
    value: nil,
    required: nil,
    disabled: nil,
    helper_text: nil,
    hide_label_required_asterisk: nil,
    compact: false,
    label_position: :top,
    grid_span: nil,
    floating_error_text: nil,
    placeholder: nil,
    size: nil,
    leading_icon_name: nil,
    trailing_icon_name: nil,
    leading_text_add_on: nil,
    trailing_text_add_on: nil,
    example_leading_add_on_slot: false,
    example_trailing_add_on_slot: false,
    input_type: :text,
    pattern: nil,
    inputmode: nil,
    numerical: nil,
    maximum_length: nil,
    minimum_length: nil,
    validate_value_equal_to_id: nil,
    min: nil,
    max: nil,
    step: nil,
    greater_than: nil,
    less_than: nil
  )
    render ::Decor::Forms::TextField.new(
      name: name,
      label: label,
      description: description,
      value: value,
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
          "<:-P"
        end
      end
      if example_trailing_add_on_slot
        field.with_trailing_add_on do
          ">:D"
        end
      end
    end
  end

  # Example of a TextField used in a form.
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
    description: "This is a description",
    show_label: true,
    compact: nil,
    required: nil,
    disabled: nil,
    helper_text: nil,
    hide_label_required_asterisk: nil,
    label_position: :left,
    grid_span: :span_half,
    floating_error_text: nil,
    placeholder: nil,
    leading_icon_name: nil,
    trailing_icon_name: nil,
    leading_text_add_on: nil,
    trailing_text_add_on: nil,
    add_on_style: :text,
    input_type: :text,
    pattern: nil,
    inputmode: nil,
    numerical: nil,
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

      prop :text, String
      prop :password, String
    end

    puts "%%%%%%%%%%%%%%%%%%%%%%%%"
    render_with_template(
      locals: {
        model: klass.new(text: "Hello", password: "Secret", persisted: false),
        stacked_form: stacked_form,
        label: label,
        description: description,
        show_label: show_label,
        compact: compact,
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
