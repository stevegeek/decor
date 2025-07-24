# @label Checkbox
# Renders a styled checkbox input with DaisyUI styling, supporting various colors, sizes, and states.
class ::Decor::Forms::CheckboxPreview < ::Lookbook::Preview
  # @group Examples

  # Basic checkbox with label
  def default
    render ::Decor::Forms::Checkbox.new(
      name: "terms",
      label: "I agree to the terms and conditions"
    )
  end

  # Checkbox with helper text and required state
  def with_helper_text
    render ::Decor::Forms::Checkbox.new(
      name: "subscribe",
      label: "Subscribe to newsletter",
      helper_text: "You can unsubscribe at any time",
      required: true
    )
  end

  # Pre-checked checkbox with custom color
  def checked_with_color
    render ::Decor::Forms::Checkbox.new(
      name: "notifications",
      label: "Enable email notifications",
      checked: true,
      color: :success
    )
  end

  # Checkbox group for multiple selections
  def checkbox_group
    render_with_template(
      template: "decor/forms/checkbox_preview/checkbox_group"
    )
  end

  # @!endgroup

  # @group Playground

  # Interactive checkbox with all available options
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
  # @param color select [~, primary, secondary, accent, neutral, success, warning, info, error]
  # @param size select [~, xs, sm, md, lg, xl]
  # @param style select [~, default]
  # @param checked toggle
  # @param part_of_group toggle
  def playground(
    name: "checkbox-1",
    label: "Check me!",
    description: nil,
    label_position: :right,
    grid_span: nil,
    compact: false,
    floating_error_text: false,
    placeholder: nil,
    value: nil,
    required: false,
    disabled: false,
    helper_text: nil,
    hide_label_required_asterisk: false,
    checked: false,
    part_of_group: false,
    color: nil,
    size: nil,
    style: nil
  )
    render ::Decor::Forms::Checkbox.new(
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
      size: size,
      style: style
    )
  end

  # @!endgroup

  # @group Colors

  # All available checkbox colors
  def colors
    render_with_template(
      template: "decor/forms/checkbox_preview/colors"
    )
  end

  # @!endgroup

  # @group Sizes

  # All available checkbox sizes
  def sizes
    render_with_template(
      template: "decor/forms/checkbox_preview/sizes"
    )
  end

  # @!endgroup

  # @group States

  # Disabled checkbox
  def disabled
    render ::Decor::Forms::Checkbox.new(
      name: "disabled_example",
      label: "This checkbox is disabled",
      disabled: true
    )
  end

  # Required checkbox with asterisk
  def required
    render ::Decor::Forms::Checkbox.new(
      name: "required_example",
      label: "This field is required",
      required: true
    )
  end

  # @!endgroup

  # @group Form Integration

  # Checkbox within a form context
  # @param stacked_form toggle
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
  # @param checked toggle
  def in_form(
    stacked_form: true,
    label: "In a form!",
    description: nil,
    show_label: true,
    label_position: :left,
    grid_span: nil,
    compact: false,
    floating_error_text: false,
    placeholder: nil,
    value: nil,
    required: false,
    disabled: false,
    helper_text: nil,
    hide_label_required_asterisk: false,
    checked: false
  )
    klass = Class.new(TypedForm) do
      def self.name
        "TestClass"
      end

      prop :chosen, _Boolean, default: false
      prop :chosen_other, _Boolean, default: false
    end

    render_with_template(
      locals: {
        stacked_form: stacked_form,
        model: klass.new(chosen: !!value, chosen_other: false),
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

  # @!endgroup
end
