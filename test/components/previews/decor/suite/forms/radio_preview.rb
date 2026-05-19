# frozen_string_literal: true

# @label Radio
class ::Decor::Suite::Forms::RadioPreview < ::Lookbook::Preview
  # @group Examples

  # @label Default
  def default
    render ::Decor::Suite::Forms::Radio.new(
      name: "subscription_plan",
      value: "monthly",
      label: "Monthly billing"
    )
  end

  # @label Checked
  def checked
    render ::Decor::Suite::Forms::Radio.new(
      name: "shipping",
      value: "express",
      label: "Express shipping",
      checked: true
    )
  end

  # @label Required with helper text
  def with_helper_text
    render ::Decor::Suite::Forms::Radio.new(
      name: "contact_method",
      value: "email",
      label: "Email me",
      helper_text: "We will reply within one business day.",
      required: true
    )
  end

  # @label Error state
  def errored
    render ::Decor::Suite::Forms::Radio.new(
      name: "agreement",
      value: "yes",
      label: "I agree",
      required: true,
      error_messages: ["Pick an option to continue."]
    )
  end

  # @label Disabled
  def disabled
    render ::Decor::Suite::Forms::Radio.new(
      name: "feature_tier",
      value: "enterprise",
      label: "Enterprise tier (upgrade required)",
      disabled: true
    )
  end

  # @label In a group (required, no asterisk)
  def in_group
    render ::Decor::Suite::Forms::Radio.new(
      name: "plan",
      value: "pro",
      label: "Pro",
      checked: true,
      required: true,
      in_group: true
    )
  end

  # @group Playground
  # @param label text
  # @param value text
  # @param helper_text text
  # @param checked toggle
  # @param required toggle
  # @param disabled toggle
  # @param in_group toggle
  # @param label_position [Symbol] select [right, left]
  def playground(
    label: "Choose me",
    value: "option_a",
    helper_text: nil,
    checked: false,
    required: false,
    disabled: false,
    in_group: false,
    label_position: :right
  )
    render ::Decor::Suite::Forms::Radio.new(
      name: "playground",
      value: value,
      label: label,
      helper_text: helper_text,
      checked: checked,
      required: required,
      disabled: disabled,
      in_group: in_group,
      label_position: label_position
    )
  end
end
