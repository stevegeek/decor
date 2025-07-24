# @label ButtonRadioGroup
class ::Decor::Forms::ButtonRadioGroupPreview < ::Lookbook::Preview
  # -------
  #
  # A ButtonRadioGroup is a radio group, styled as a set of toggle buttons. The
  # behaviour is controlled by a StimulusJS controller. The component is a type of FormField component.
  #
  # Form field attrs
  # @param name text
  # @param label text
  # @param description text
  # @param label_position [Symbol] select [~, top, left, right, inline, inside]
  # @param grid_span [Symbol] select [~, span_1, span_2, span_half, span_4, span_5, span_full]
  # @param floating_error_text toggle
  # @param selected_choice select ["yes", "no", "maybe"]
  # @param color [Symbol] select [~, primary, secondary, accent, neutral, success, warning, info, error]
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param style [Symbol] select [~, outline, solid, ghost, link]
  # @param required toggle
  # @param hide_label_required_asterisk toggle
  # @param disabled toggle
  # @param helper_text text
  # @param value text
  def playground(
    name: "button-radio-group-1",
    label: "Select one",
    description: nil,
    selected_choice: "yes",
    color: :primary,
    size: :md,
    style: :outlined,
    label_position: :top,
    grid_span: nil,
    floating_error_text: false,
    value: nil,
    required: false,
    disabled: false,
    helper_text: nil,
    hide_label_required_asterisk: false
  )
    render ::Decor::Forms::ButtonRadioGroup.new(
      choices: [["yes", "Yes"], ["no", "No"], ["maybe", "Maybe"]],
      selected_choice: selected_choice,
      name: name,
      label: label,
      description: description,
      color: color,
      size: size,
      style: style,
      label_position: label_position,
      grid_span: grid_span,
      floating_error_text: floating_error_text,
      value: value,
      required: required,
      disabled: disabled,
      helper_text: helper_text,
      hide_required_asterisk: hide_label_required_asterisk
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
  # @param floating_error_text toggle
  # @param selected_choice select [~, "yes", "no", "maybe"]
  # @param color [Symbol] select [~, primary, secondary, accent, neutral, success, warning, info, error]
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param style [Symbol] select [~, outline, solid, ghost, link]
  # @param required toggle
  # @param hide_label_required_asterisk toggle
  # @param disabled toggle
  # @param helper_text text
  # @param value text
  def in_form(
    stacked_form: true,
    label: "In a form!",
    description: nil,
    selected_choice: nil,
    color: :primary,
    size: :md,
    style: :outlined,
    show_label: true,
    label_position: :left,
    grid_span: nil,
    floating_error_text: false,
    value: nil,
    required: false,
    disabled: false,
    helper_text: nil,
    hide_label_required_asterisk: false
  )
    klass = Class.new(TypedForm) do
      def self.name
        "TestClass"
      end

      prop :chosen, String
    end

    render_with_template(
      locals: {
        stacked_form: stacked_form,
        model: klass.new(chosen: selected_choice || ""),
        choices: [["yes", "Yes"], ["no", "No"], ["maybe", "Maybe"]],
        label: label,
        description: description,
        color: color,
        size: size,
        style: style,
        label_position: label_position,
        grid_span: grid_span,
        floating_error_text: floating_error_text,
        selected_choice: selected_choice,
        show_label: show_label,
        value: value,
        required: required,
        disabled: disabled,
        helper_text: helper_text,
        hide_required_asterisk: hide_label_required_asterisk
      }
    )
  end
end
