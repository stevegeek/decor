# @label Switch
# A toggle switch component that renders as a styled checkbox input.
class ::Decor::Forms::SwitchPreview < ::Lookbook::Preview
  # @!group Examples

  # Basic switch with label
  def default
    render ::Decor::Forms::Switch.new(
      name: "notifications",
      label: "Enable notifications",
      checked: true
    )
  end

  # Switch with helper text and description
  def with_helper_text
    render ::Decor::Forms::Switch.new(
      name: "auto_save",
      label: "Auto-save",
      description: "Automatically save your work",
      helper_text: "Changes will be saved every 30 seconds",
      checked: true
    )
  end

  # Disabled switch
  def disabled_state
    render ::Decor::Forms::Switch.new(
      name: "maintenance_mode",
      label: "Maintenance mode",
      disabled: true,
      helper_text: "This setting is locked by an administrator"
    )
  end

  # Switch that submits form on change
  # @param confirm_on_submit text
  # @param confirm_on_submit_yes text
  # @param confirm_on_submit_no text
  def submits_on_change(
    confirm_on_submit: "Are you sure you want to toggle this setting?",
    confirm_on_submit_yes: "Yes, proceed",
    confirm_on_submit_no: "Cancel"
  )
    klass = Class.new(TypedForm) do
      def self.name
        "TestClass"
      end

      prop :feature_enabled, _Boolean
    end

    model = klass.new(feature_enabled: false)

    render_with_template(
      template: "decor/forms/switch_preview/submits_form",
      locals: {
        model: model,
        stacked_form: true,
        label: "Feature toggle",
        description: "Enable experimental features",
        show_label: true,
        value: nil,
        required: nil,
        disabled: nil,
        helper_text: "This will apply immediately",
        label_position: :left,
        grid_span: nil,
        compact: nil,
        floating_error_text: nil,
        placeholder: nil,
        hide_required_asterisk: nil,
        checked: nil,
        in_group: false,
        submit_on_change: true,
        confirm_on_submit: confirm_on_submit,
        confirm_on_submit_yes: confirm_on_submit_yes,
        confirm_on_submit_no: confirm_on_submit_no
      }
    )
  end

  # @!endgroup

  # @!group Playground

  # Interactive example with all parameters
  # @param name text
  # @param label text
  # @param description text
  # @param checked toggle
  # @param disabled toggle
  # @param required toggle
  # @param hide_label_required_asterisk toggle
  # @param helper_text text
  # @param label_position [Symbol] select [~, top, left, right, inline, inside]
  # @param grid_span [Symbol] select [~, span_1, span_2, span_half, span_4, span_5, span_full]
  # @param compact toggle
  # @param floating_error_text toggle
  # @param placeholder text
  # @param value text
  # @param part_of_group toggle
  # @param color select [~, primary, secondary, accent, success, error, warning, info]
  # @param size select [~, xs, sm, md, lg]
  # @param style select [~, default]
  def playground(
    name: "toggle-1",
    label: "Toggle this setting",
    description: nil,
    checked: false,
    disabled: false,
    required: false,
    hide_label_required_asterisk: false,
    helper_text: nil,
    label_position: :left,
    grid_span: nil,
    compact: false,
    floating_error_text: false,
    placeholder: nil,
    value: nil,
    part_of_group: false,
    color: nil,
    size: nil,
    style: nil
  )
    render ::Decor::Forms::Switch.new(
      name: name,
      label: label,
      description: description,
      checked: checked,
      disabled: disabled,
      required: required,
      hide_required_asterisk: hide_label_required_asterisk,
      helper_text: helper_text,
      label_position: label_position,
      grid_span: grid_span,
      compact: compact,
      floating_error_text: floating_error_text,
      placeholder: placeholder,
      value: value,
      in_group: part_of_group,
      color: color,
      size: size,
      style: style
    )
  end

  # @!endgroup

  # @!group Colors

  # Primary color switch
  def color_primary
    render ::Decor::Forms::Switch.new(
      name: "primary_switch",
      label: "Primary color",
      color: :primary,
      checked: true
    )
  end

  # Secondary color switch
  def color_secondary
    render ::Decor::Forms::Switch.new(
      name: "secondary_switch",
      label: "Secondary color",
      color: :secondary,
      checked: true
    )
  end

  # Success color switch
  def color_success
    render ::Decor::Forms::Switch.new(
      name: "success_switch",
      label: "Success color",
      color: :success,
      checked: true
    )
  end

  # Error color switch
  def color_error
    render ::Decor::Forms::Switch.new(
      name: "error_switch",
      label: "Error color",
      color: :error,
      checked: true
    )
  end

  # All color variations
  def all_colors
    render_with_template(template: "decor/forms/switch_preview/color_and_size_examples")
  end

  # @!endgroup

  # @!group Sizes

  # Extra small size
  def size_xs
    render ::Decor::Forms::Switch.new(
      name: "xs_switch",
      label: "Extra small",
      size: :xs,
      checked: true
    )
  end

  # Small size
  def size_sm
    render ::Decor::Forms::Switch.new(
      name: "sm_switch",
      label: "Small",
      size: :sm,
      checked: true
    )
  end

  # Medium size (default)
  def size_md
    render ::Decor::Forms::Switch.new(
      name: "md_switch",
      label: "Medium",
      size: :md,
      checked: true
    )
  end

  # Large size
  def size_lg
    render ::Decor::Forms::Switch.new(
      name: "lg_switch",
      label: "Large",
      size: :lg,
      checked: true
    )
  end

  # @!endgroup

  # @!group Label Positions

  # Label on the left (default)
  def label_left
    render ::Decor::Forms::Switch.new(
      name: "left_label",
      label: "Label on left",
      label_position: :left
    )
  end

  # Label on the right
  def label_right
    render ::Decor::Forms::Switch.new(
      name: "right_label",
      label: "Label on right",
      label_position: :right
    )
  end

  # Label on top
  def label_top
    render ::Decor::Forms::Switch.new(
      name: "top_label",
      label: "Label on top",
      label_position: :top
    )
  end

  # Inline label
  def label_inline
    render ::Decor::Forms::Switch.new(
      name: "inline_label",
      label: "Inline label",
      label_position: :inline
    )
  end

  # @!endgroup

  # @!group States

  # Required switch
  def required
    render ::Decor::Forms::Switch.new(
      name: "terms",
      label: "I accept the terms and conditions",
      required: true
    )
  end

  # Switch in a group
  def in_group
    render ::Decor::Forms::Switch.new(
      name: "group_option",
      label: "Part of a group",
      in_group: true
    )
  end

  # Compact switch
  def compact
    render ::Decor::Forms::Switch.new(
      name: "compact_switch",
      label: "Compact switch",
      compact: true,
      helper_text: "Takes up less vertical space"
    )
  end

  # @!endgroup
end
