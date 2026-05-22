# @label ButtonLink
class ::Decor::Suite::ButtonLinkPreview < ::Lookbook::Preview
  # @group Examples
  # @label Default
  def default
    render ::Decor::Suite::ButtonLink.new(label: "Visit page", href: "#")
  end

  # @label Primary filled
  def primary_filled
    render ::Decor::Suite::ButtonLink.new(label: "Continue", href: "#", color: :primary, style: :filled)
  end

  # @label Outlined primary
  def outlined_primary
    render ::Decor::Suite::ButtonLink.new(label: "Learn more", href: "#", color: :primary, style: :outlined)
  end

  # @label Soft danger
  def soft_danger
    render ::Decor::Suite::ButtonLink.new(label: "Reject", href: "#", color: :error, style: :soft)
  end

  # @label Ghost
  def ghost
    render ::Decor::Suite::ButtonLink.new(label: "Cancel", href: "#", style: :ghost)
  end

  # @label With icon
  def with_icon
    render ::Decor::Suite::ButtonLink.new(label: "Star", href: "#", icon: "star", color: :primary)
  end

  # @label Disabled (renders as <button>)
  def disabled
    render ::Decor::Suite::ButtonLink.new(label: "Unavailable", href: "#", disabled: true, color: :primary)
  end

  # @label Sizes
  def sizes
    render ::Decor::Suite::ButtonLink.new(label: "Sample", href: "#", size: :md, color: :primary)
  end

  # @label Delete action (Turbo)
  def turbo_delete
    render ::Decor::Suite::ButtonLink.new(label: "Delete", href: "#", http_method: :delete, color: :error, style: :outlined, turbo_confirm: "Are you sure?")
  end

  # @group Playground
  # @param label text
  # @param href text
  # @param color [Symbol] select [base, primary, success, warning, error, info]
  # @param style [Symbol] select [filled, outlined, ghost, soft]
  # @param size [Symbol] select [xs, sm, md, lg, xl]
  # @param disabled toggle
  # @param full_width toggle
  # @param icon text
  def playground(label: "Click me", href: "#", color: :base, style: :filled, size: :sm, disabled: false, full_width: false, icon: nil)
    render ::Decor::Suite::ButtonLink.new(
      label: label, href: href, color: color, style: style, size: size,
      disabled: disabled, full_width: full_width, icon: icon.presence
    )
  end
end
