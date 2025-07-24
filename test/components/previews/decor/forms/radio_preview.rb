# @label Radio
# Radio buttons allow users to select one option from a group. Built with DaisyUI styling.
class ::Decor::Forms::RadioPreview < ::Lookbook::Preview
  # @group Examples

  # Basic radio button
  def default
    render ::Decor::Forms::Radio.new(
      name: "options",
      label: "Select this option",
      value: "option1"
    )
  end

  # Radio group with multiple options
  def radio_group
    render_with_template(
      template: "decor/forms/radio_preview/examples/radio_group"
    )
  end

  # Radio with states and helper text
  def with_states
    render_with_template(
      template: "decor/forms/radio_preview/examples/with_states"
    )
  end

  # Radio buttons in a form
  # @param stacked_form toggle
  def in_form(stacked_form: true)
    klass = Class.new(TypedForm) do
      def self.name
        "TestClass"
      end

      prop :chosen, _Boolean
    end

    render_with_template(
      locals: {
        stacked_form: stacked_form,
        model: klass.new(chosen: false)
      }
    )
  end

  # @endgroup

  # @group Playground

  # Interactive radio with all options
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
  # @param checked toggle
  # @param part_of_group toggle
  # @param size select [xs, sm, md, lg, xl]
  # @param color select [primary, secondary, accent, neutral, success, warning, info, error]
  # @param style select [~, filled, bordered, ghost]
  def playground(
    name: "radio-option",
    label: "Select me!",
    description: nil,
    label_position: :right,
    grid_span: nil,
    compact: false,
    floating_error_text: false,
    placeholder: nil,
    value: "option1",
    required: false,
    disabled: false,
    helper_text: nil,
    hide_label_required_asterisk: false,
    checked: false,
    part_of_group: false,
    size: :md,
    color: :primary,
    style: nil
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
      size: size,
      color: color,
      style: style
    )
  end

  # @endgroup

  # @group Properties

  # Available colors
  def colors
    render_with_template(
      template: "decor/forms/radio_preview/properties/colors"
    )
  end

  # Available sizes
  def sizes
    render_with_template(
      template: "decor/forms/radio_preview/properties/sizes"
    )
  end

  # Label positions
  def label_positions
    render_with_template(
      template: "decor/forms/radio_preview/properties/label_positions"
    )
  end

  # @endgroup
end
