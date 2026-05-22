# frozen_string_literal: true

# @label Checkbox
class ::Decor::Suite::Forms::CheckboxPreview < ::Lookbook::Preview
  # @group Examples

  # @label Default
  def default
    render ::Decor::Suite::Forms::Checkbox.new(
      name: "newsletter",
      label: "Subscribe to the newsletter"
    )
  end

  # @label Checked
  def checked
    render ::Decor::Suite::Forms::Checkbox.new(
      name: "terms",
      label: "I agree to the terms",
      checked: true
    )
  end

  # @label Required with helper text
  def with_helper_text
    render ::Decor::Suite::Forms::Checkbox.new(
      name: "marketing_emails",
      label: "Send marketing emails",
      helper_text: "We will only contact you about new product releases.",
      required: true
    )
  end

  # @label Error state
  def errored
    render ::Decor::Suite::Forms::Checkbox.new(
      name: "terms",
      label: "I agree to the terms",
      required: true,
      error_messages: ["You must accept the terms to continue."]
    )
  end

  # @label Disabled
  def disabled
    render ::Decor::Suite::Forms::Checkbox.new(
      name: "feature",
      label: "Premium feature (upgrade required)",
      disabled: true
    )
  end

  # @label Label on top
  def label_top
    render ::Decor::Suite::Forms::Checkbox.new(
      name: "opt_in",
      label: "Receive notifications",
      label_position: :top
    )
  end

  # @group Playground
  # @param label text
  # @param helper_text text
  # @param checked toggle
  # @param required toggle
  # @param disabled toggle
  # @param in_group toggle
  # @param label_position [Symbol] select [right, left, top]
  def playground(
    label: "I agree to the terms",
    helper_text: nil,
    checked: false,
    required: false,
    disabled: false,
    in_group: false,
    label_position: :right
  )
    render ::Decor::Suite::Forms::Checkbox.new(
      name: "playground",
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
