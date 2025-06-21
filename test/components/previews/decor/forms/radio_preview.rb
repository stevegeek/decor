# @label Radio
class ::Decor::Forms::RadioPreview < ::Lookbook::Preview
  # Radio
  # -------
  #
  # A Radio uses DaisyUI's radio component styling. It renders as a radio
  # input with DaisyUI styling. Radio buttons are used to select one option from a group.
  #
  # Form field attrs
  # @param name text
  # @param label text
  # @param description text
  # @param label_position [Symbol] select [~, top, left, right, inline, inside]
  # @param grid_span [Symbol] select [~, span_1, span_2, span_half, span_4, span_5, span_full]
  # @param compact toggle
  # @param floating_error_text toggle
  # @param placeholder text
  # @param required toggle
  # @param hide_label_required_asterisk toggle
  # @param disabled toggle
  # @param helper_text text
  # @param value text
  # @param color select [primary, secondary, accent, neutral, success, warning, info, error]
  # @param size select [xs, sm, md, lg, xl]
  #
  # Radio attrs
  # @param checked toggle
  # @param part_of_group toggle
  def playground(
    name: "radio-group",
    label: "Select me!",
    description: nil,
    label_position: nil,
    grid_span: nil,
    compact: nil,
    floating_error_text: nil,
    placeholder: nil,
    value: "option1",
    required: nil,
    disabled: nil,
    helper_text: nil,
    hide_label_required_asterisk: nil,
    checked: nil,
    part_of_group: nil,
    color: :primary,
    size: :md
  )
    render ::Decor::Forms::Radio.new(
      name: name,
      label: label,
      description: description,
      compact: compact,
      label_position: label_position,
      grid_span: grid_span,
      floating_error_text: floating_error_text,
      placeholder: placeholder,
      value: value,
      required: required,
      disabled: disabled,
      helper_text: helper_text,
      hide_required_asterisk: hide_label_required_asterisk,
      checked: checked,
      in_group: part_of_group,
      color: color,
      size: size
    )
  end

  # @param stacked_form toggle
  #
  # Form field attrs
  # @param label text
  # @param description text
  # @param show_label toggle
  # @param label_position [Symbol] select [~, top, left, right, inline, inside]
  # @param grid_span [Symbol] select [~, span_1, span_2, span_half, span_4, span_5, span_full]
  # @param compact toggle
  # @param floating_error_text toggle
  # @param placeholder text
  # @param required toggle
  # @param hide_label_required_asterisk toggle
  # @param disabled toggle
  # @param helper_text text
  # @param value text
  #
  # Checkbox attrs
  # @param checked toggle
  def in_form(
    stacked_form: true,
    label: "In a form!",
    description: nil,
    show_label: true,
    label_position: :left,
    grid_span: nil,
    compact: nil,
    floating_error_text: nil,
    placeholder: nil,
    value: nil,
    required: nil,
    disabled: nil,
    helper_text: nil,
    hide_label_required_asterisk: nil,
    checked: nil
  )
    klass = Class.new(TypedForm) do
      def self.name
        "TestClass"
      end

      prop :chosen, _Boolean
    end

    render_with_template(
      locals: {
        stacked_form: stacked_form,
        model: klass.new(chosen: false),
        label: label,
        description: description,
        show_label: show_label,
        compact: compact,
        label_position: label_position,
        grid_span: grid_span,
        floating_error_text: floating_error_text,
        placeholder: placeholder,
        value: value,
        required: required,
        disabled: disabled,
        helper_text: helper_text,
        hide_required_asterisk: hide_label_required_asterisk,
        checked: checked
      }
    )
  end

  # DaisyUI Colors and Sizes
  # ------------------------
  #
  # Showcase the different color and size options available with DaisyUI radio styling.
  def color_and_size_examples
    render_with_template
  end
end
