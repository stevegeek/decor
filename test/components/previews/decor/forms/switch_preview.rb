# @label Switch
class ::Decor::Forms::SwitchPreview < ::Lookbook::Preview
  # Switch
  # -------
  #
  # A Switch or "toggle" uses DaisyUI's toggle component styling. It renders as a checkbox
  # input with toggle styling. The component is a type of FormField component.
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
  # @param color select [primary, secondary, accent, success, error, warning, info]
  # @param size select [xs, sm, md, lg]
  #
  # Checkbox attrs
  # @param checked toggle
  # @param part_of_group toggle
  def playground(
    name: "toggle-1",
    label: "Switch me!",
    description: nil,
    label_position: nil,
    grid_span: nil,
    compact: nil,
    floating_error_text: nil,
    placeholder: nil,
    value: nil,
    required: nil,
    disabled: nil,
    helper_text: nil,
    hide_label_required_asterisk: nil,
    checked: nil,
    part_of_group: nil,
    color: :primary,
    size: :md
  )
    render ::Decor::Forms::Switch.new(
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

  # Switches can cause the form their are in to submit and optionally have a confirmation dialog.
  #
  # @param stacked_form toggle
  #
  # Form field attrs
  # @param label text
  # @param description text
  # @param show_label toggle
  # @param required toggle
  # @param hide_label_required_asterisk toggle
  # @param disabled toggle
  # @param helper_text text
  # @param label_position [Symbol] select [~, top, left, right, inline, inside]
  # @param grid_span [Symbol] select [~, span_1, span_2, span_half, span_4, span_5, span_full]
  # @param compact toggle
  # @param floating_error_text toggle
  # @param placeholder text
  # @param value text
  #
  # Checkbox attrs
  # @param checked toggle
  # @param part_of_group toggle
  #
  # Component attrs
  # @param submit_on_change toggle
  # @param confirm_on_submit text
  # @param confirm_on_submit_yes text
  # @param confirm_on_submit_no text
  def submits_form(
    stacked_form: true,
    label: "Switch me!",
    description: nil,
    show_label: true,
    value: nil,
    required: nil,
    disabled: nil,
    helper_text: nil,
    label_position: :left,
    grid_span: nil,
    compact: nil,
    floating_error_text: nil,
    placeholder: nil,
    hide_label_required_asterisk: nil,
    checked: nil,
    part_of_group: nil,
    submit_on_change: nil,
    confirm_on_submit: nil,
    confirm_on_submit_yes: nil,
    confirm_on_submit_no: nil
  )
    klass = Class.new(TypedForm) do
      def self.name
        "TestClass"
      end

      prop :chosen, _Boolean
    end

    render_with_template(
      locals: {
        model: klass.new(chosen: false),
        stacked_form: stacked_form,
        label: label,
        description: description,
        show_label: show_label,
        value: value,
        required: required,
        disabled: disabled,
        helper_text: helper_text,
        label_position: label_position,
        grid_span: grid_span,
        compact: compact,
        floating_error_text: floating_error_text,
        placeholder: placeholder,
        hide_required_asterisk: hide_label_required_asterisk,
        checked: checked,
        in_group: part_of_group,
        submit_on_change: submit_on_change,
        confirm_on_submit: confirm_on_submit,
        confirm_on_submit_yes: confirm_on_submit_yes,
        confirm_on_submit_no: confirm_on_submit_no
      }
    )
  end

  # DaisyUI Colors and Sizes
  # ------------------------
  #
  # Showcase the different color and size options available with DaisyUI toggle styling.
  def color_and_size_examples
    render_with_template
  end
end
