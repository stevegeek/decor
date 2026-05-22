# @label Switch
class ::Decor::Suite::Forms::SwitchPreview < ::Lookbook::Preview
  # @group Examples
  # @label Default (off)
  def example_default
    render ::Decor::Suite::Forms::Switch.new(
      name: "notifications",
      label: "Email notifications"
    )
  end

  # @group Examples
  # @label Checked
  def example_checked
    render ::Decor::Suite::Forms::Switch.new(
      name: "notifications",
      label: "Email notifications",
      checked: true
    )
  end

  # @group Examples
  # @label Label on top
  def example_label_top
    render ::Decor::Suite::Forms::Switch.new(
      name: "marketing",
      label: "Marketing emails",
      label_position: :top,
      helper_text: "Receive product updates and announcements."
    )
  end

  # @group Examples
  # @label With helper text
  def example_with_helper
    render ::Decor::Suite::Forms::Switch.new(
      name: "two_factor",
      label: "Two-factor authentication",
      checked: true,
      helper_text: "Requires a code from your authenticator app on each sign-in."
    )
  end

  # @group States
  # @label Disabled (off)
  def state_disabled_off
    render ::Decor::Suite::Forms::Switch.new(
      name: "feature_x",
      label: "Beta feature",
      disabled: true
    )
  end

  # @group States
  # @label Disabled (on)
  def state_disabled_on
    render ::Decor::Suite::Forms::Switch.new(
      name: "feature_x",
      label: "Beta feature",
      checked: true,
      disabled: true
    )
  end

  # @group States
  # @label Error
  def state_error
    render ::Decor::Suite::Forms::Switch.new(
      name: "accept_terms",
      label: "I accept the terms",
      required: true,
      error_messages: ["You must accept the terms to continue."]
    )
  end

  # @group Colors
  # @label Success (on)
  def color_success
    render ::Decor::Suite::Forms::Switch.new(
      name: "success_switch",
      label: "Backups enabled",
      checked: true,
      color: :success
    )
  end

  # @group Colors
  # @label Warning (on)
  def color_warning
    render ::Decor::Suite::Forms::Switch.new(
      name: "warning_switch",
      label: "Maintenance mode",
      checked: true,
      color: :warning
    )
  end

  # @group Playground
  # @param label text
  # @param helper_text text
  # @param checked toggle
  # @param disabled toggle
  # @param required toggle
  # @param color [Symbol] select [~, primary, success, warning, error]
  # @param label_position [Symbol] select [right, top, inline, left]
  def playground(
    label: "Enable feature",
    helper_text: "An optional explanation.",
    checked: false,
    disabled: false,
    required: false,
    color: :primary,
    label_position: :right
  )
    render ::Decor::Suite::Forms::Switch.new(
      name: "playground",
      label: label,
      helper_text: helper_text,
      checked: checked,
      disabled: disabled,
      required: required,
      color: color,
      label_position: label_position
    )
  end
end
