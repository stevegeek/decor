# @label TextArea
class ::Decor::Forms::TextAreaPreview < ::Lookbook::Preview
  # TextArea
  # -------
  #
  # A textarea input. Offers similar functionality to a text field element.
  #
  # Form field attrs
  # @param name text
  # @param label text
  # @param description text
  # @param compact toggle
  # @param label_position select [~, top, left, right, inline, inside]
  # @param grid_span [Symbol] select [~, span_1, span_2, span_half, span_4, span_5, span_full]
  # @param floating_error_text toggle
  # @param placeholder text
  # @param required toggle
  # @param hide_label_required_asterisk toggle
  # @param disabled toggle
  # @param helper_text text
  # @param value text
  #
  # TextArea attrs:
  # @param rows number
  # @param cols number
  # @param pattern text
  # @param maximum_length number
  # @param minimum_length number
  # @param color select [primary, secondary, accent, success, error, warning, info]
  # @param size select [xs, sm, md, lg]
  def playground(
    name: "text-area-1",
    label: "What is your story?",
    description: nil,
    value: nil,
    required: false,
    disabled: false,
    helper_text: nil,
    hide_label_required_asterisk: false,
    compact: false,
    label_position: :top,
    grid_span: nil,
    floating_error_text: false,
    placeholder: nil,
    rows: 5,
    cols: nil,
    pattern: nil,
    maximum_length: nil,
    minimum_length: nil,
    color: :primary,
    size: :md
  )
    render ::Decor::Forms::TextArea.new(
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
      rows: rows,
      cols: cols,
      pattern: pattern,
      maximum_length: maximum_length,
      minimum_length: minimum_length,
      color: color,
      size: size
    )
  end

  # Example of a TextArea used in a form.
  #
  # @param stacked_form toggle
  #
  # Form field attrs
  # @param label text
  # @param description text
  # @param compact toggle
  # @param label_position select [~, top, left, right, inline, inside]
  # @param grid_span [Symbol] select [~, span_1, span_2, span_half, span_4, span_5, span_full]
  # @param floating_error_text toggle
  # @param placeholder text
  # @param required toggle
  # @param hide_label_required_asterisk toggle
  # @param disabled toggle
  # @param helper_text text
  # @param value text
  #
  # TextArea attrs:
  # @param pattern text
  # @param maximum_length number
  # @param minimum_length number
  def in_form(
    stacked_form: true,
    label: "What is your story?",
    description: nil,
    value: nil,
    required: nil,
    disabled: nil,
    helper_text: nil,
    hide_label_required_asterisk: nil,
    compact: false,
    label_position: :left,
    grid_span: :span_half,
    floating_error_text: nil,
    placeholder: nil,
    pattern: nil,
    maximum_length: nil,
    minimum_length: nil
  )
    klass = Class.new(TypedForm) do
      def self.name
        "TestClass"
      end

      prop :text, String
    end

    render_with_template(
      locals: {
        model: klass.new(text: ""),
        stacked_form: stacked_form,
        label: label,
        description: description,
        value: value,
        required: required,
        disabled: disabled,
        helper_text: helper_text,
        hide_label_required_asterisk: hide_label_required_asterisk,
        compact: compact,
        label_position: label_position,
        grid_span: grid_span,
        floating_error_text: floating_error_text,
        placeholder: placeholder,
        pattern: pattern,
        maximum_length: maximum_length,
        minimum_length: minimum_length
      }
    )
  end

  # DaisyUI Colors and Sizes
  # ------------------------
  #
  # Showcase the different color and size options available with DaisyUI styling.
  def color_and_size_examples
    render_with_template
  end
end
