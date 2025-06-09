# @label Link
class ::Decor::LinkPreview < ::ViewComponent::Preview
  # Link
  # -------
  #
  # A styled anchor link component with daisyUI btn-link styling.
  # Supports different themes for color, sizes, and disabled state.
  #
  # @label Playground
  # @param label text
  # @param href text
  # @param theme select {choices: [primary, secondary, danger, warning, neutral]}
  # @param size select {choices: [large, medium, small, micro]}
  # @param disabled toggle
  # @param icon select [~, check-circle, x, check, download, play]
  def playground(label: "Click me", href: "#", theme: :primary, size: :medium, disabled: false, icon: nil)
    render ::Decor::Link.new(
      label: label,
      href: href,
      theme: theme.to_sym,
      size: size.to_sym,
      disabled: disabled,
      icon: icon.present? ? icon : nil
    )
  end

  # @group Themes
  # @label Primary Theme
  def theme_primary
    render ::Decor::Link.new(label: "Primary Link", href: "#", theme: :primary)
  end

  # @group Themes
  # @label Secondary Theme
  def theme_secondary
    render ::Decor::Link.new(label: "Secondary Link", href: "#", theme: :secondary)
  end

  # @group Themes
  # @label Danger Theme
  def theme_danger
    render ::Decor::Link.new(label: "Danger Link", href: "#", theme: :danger)
  end

  # @group Themes
  # @label Warning Theme
  def theme_warning
    render ::Decor::Link.new(label: "Warning Link", href: "#", theme: :warning)
  end

  # @group Themes
  # @label Neutral Theme
  def theme_neutral
    render ::Decor::Link.new(label: "Neutral Link", href: "#", theme: :neutral)
  end

  # @group Sizes
  # @label Large Size
  def size_large
    render ::Decor::Link.new(label: "Large Link", href: "#", size: :large)
  end

  # @group Sizes
  # @label Medium Size
  def size_medium
    render ::Decor::Link.new(label: "Medium Link", href: "#", size: :medium)
  end

  # @group Sizes
  # @label Small Size
  def size_small
    render ::Decor::Link.new(label: "Small Link", href: "#", size: :small)
  end

  # @group Sizes
  # @label Micro Size
  def size_micro
    render ::Decor::Link.new(label: "Micro Link", href: "#", size: :micro)
  end

  # @group With Icons
  # @label Basic Icon
  def icon_basic
    render ::Decor::Link.new(label: "Link with icon", href: "#", icon: "star")
  end

  # @group With Icons
  # @label Large with Icon
  def icon_large
    render ::Decor::Link.new(label: "Large with icon", href: "#", icon: "heart", size: :large)
  end

  # @group With Icons
  # @label Small with Icon
  def icon_small
    render ::Decor::Link.new(label: "Small with icon", href: "#", icon: "bell", size: :small)
  end

  # @group Disabled States
  # @label Disabled Primary
  def disabled_primary
    render ::Decor::Link.new(label: "Disabled Primary", href: "#", theme: :primary, disabled: true)
  end

  # @group Disabled States
  # @label Disabled Secondary
  def disabled_secondary
    render ::Decor::Link.new(label: "Disabled Secondary", href: "#", theme: :secondary, disabled: true)
  end

  # @group Disabled States
  # @label Disabled Danger
  def disabled_danger
    render ::Decor::Link.new(label: "Disabled Danger", href: "#", theme: :danger, disabled: true)
  end

  # @group External Links
  # @label External Website
  def external_website
    render ::Decor::Link.new(label: "External Link", href: "https://example.com", target: "_blank")
  end

  # @group External Links
  # @label Email Link
  def external_email
    render ::Decor::Link.new(label: "Email Link", href: "mailto:test@example.com")
  end

  # @group External Links
  # @label Phone Link
  def external_phone
    render ::Decor::Link.new(label: "Phone Link", href: "tel:+1234567890")
  end

  # @group Turbo Methods
  # @label DELETE Request
  def turbo_delete
    render ::Decor::Link.new(label: "DELETE request", href: "/delete-item", http_method: :delete, theme: :danger)
  end

  # @group Turbo Methods
  # @label POST Request
  def turbo_post
    render ::Decor::Link.new(label: "POST request", href: "/create-item", http_method: :post, theme: :primary)
  end

  # @group Turbo Methods
  # @label PATCH Request
  def turbo_patch
    render ::Decor::Link.new(label: "PATCH request", href: "/update-item", http_method: :patch, theme: :secondary)
  end

  # @group Turbo Frames
  # @label Modal Frame
  def turbo_frame_modal
    render ::Decor::Link.new(label: "Load in modal frame", href: "/modal-content", turbo_frame: "modal")
  end

  # @group Turbo Frames
  # @label Top Frame
  def turbo_frame_top
    render ::Decor::Link.new(label: "Replace entire page", href: "/new-page", turbo_frame: "_top")
  end

  # @group Turbo Frames
  # @label Sidebar Frame
  def turbo_frame_sidebar
    render ::Decor::Link.new(label: "Load in sidebar", href: "/sidebar-content", turbo_frame: "sidebar")
  end

  # @group Turbo Features
  # @label Turbo Confirmation
  def turbo_confirm
    render ::Decor::Link.new(
      label: "Delete with confirmation",
      href: "/dangerous-action",
      http_method: :delete,
      turbo_confirm: "Are you sure you want to delete this?",
      theme: :danger
    )
  end

  # @group Turbo Features
  # @label Disable Turbo
  def turbo_disabled
    render ::Decor::Link.new(
      label: "Full page reload (no Turbo)",
      href: "/full-reload",
      turbo: false
    )
  end

  # @group Turbo Features
  # @label Prefetch on Hover
  def turbo_prefetch_hover
    render ::Decor::Link.new(
      label: "Prefetch on hover",
      href: "/prefetch-hover",
      turbo_prefetch: :hover
    )
  end

  # @group Turbo Features
  # @label Prefetch on Viewport
  def turbo_prefetch_viewport
    render ::Decor::Link.new(
      label: "Prefetch when visible",
      href: "/prefetch-viewport",
      turbo_prefetch: :viewport
    )
  end
end
