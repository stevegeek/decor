# @label ButtonLink
class ::Decor::ButtonLinkPreview < ::ViewComponent::Preview
  # ButtonLinks
  # -------
  #
  # A button that is rendered with a link tag when enabled, or as a button when disabled.
  # Supports all Button styling with ActsAsLink functionality.
  #
  # @label Playground
  # @param label text
  # @param href text
  # @param http_method select [~, get, post, put, patch, delete]
  # @param disabled toggle
  # @param icon select [~, check-circle, x, check, download, play]
  # @param variant select [contained, outlined, text]
  # @param theme select [primary, secondary, danger, warning, neutral]
  # @param size select [medium, large, wide, small, micro]
  # @param full_width toggle
  def playground(
    label: "Button Link",
    href: "https://www.google.com",
    http_method: :get,
    icon: nil,
    variant: :contained,
    theme: :primary,
    size: :medium,
    disabled: false,
    full_width: false
  )
    render ::Decor::ButtonLink.new(
      label: label,
      href: href,
      http_method: http_method,
      icon: icon,
      variant: variant,
      theme: theme,
      size: size,
      disabled: disabled,
      full_width: full_width
    )
  end

  # @group Themes
  # @label Primary Theme
  def theme_primary
    render ::Decor::ButtonLink.new(label: "Primary Link", href: "#", theme: :primary)
  end

  # @group Themes
  # @label Secondary Theme
  def theme_secondary
    render ::Decor::ButtonLink.new(label: "Secondary Link", href: "#", theme: :secondary)
  end

  # @group Themes
  # @label Danger Theme
  def theme_danger
    render ::Decor::ButtonLink.new(label: "Danger Link", href: "#", theme: :danger)
  end

  # @group Themes
  # @label Warning Theme
  def theme_warning
    render ::Decor::ButtonLink.new(label: "Warning Link", href: "#", theme: :warning)
  end

  # @group Themes
  # @label Neutral Theme
  def theme_neutral
    render ::Decor::ButtonLink.new(label: "Neutral Link", href: "#", theme: :neutral)
  end

  # @group Variants
  # @label Contained Variant
  def variant_contained
    render ::Decor::ButtonLink.new(label: "Contained Link", href: "#", variant: :contained)
  end

  # @group Variants
  # @label Outlined Variant
  def variant_outlined
    render ::Decor::ButtonLink.new(label: "Outlined Link", href: "#", variant: :outlined)
  end

  # @group Variants
  # @label Text Variant
  def variant_text
    render ::Decor::ButtonLink.new(label: "Text Link", href: "#", variant: :text)
  end

  # @group Sizes
  # @label Large Size
  def size_large
    render ::Decor::ButtonLink.new(label: "Large Link", href: "#", size: :large)
  end

  # @group Sizes
  # @label Medium Size
  def size_medium
    render ::Decor::ButtonLink.new(label: "Medium Link", href: "#", size: :medium)
  end

  # @group Sizes
  # @label Wide Size
  def size_wide
    render ::Decor::ButtonLink.new(label: "Wide Link", href: "#", size: :wide)
  end

  # @group Sizes
  # @label Small Size
  def size_small
    render ::Decor::ButtonLink.new(label: "Small Link", href: "#", size: :small)
  end

  # @group Sizes
  # @label Micro Size
  def size_micro
    render ::Decor::ButtonLink.new(label: "Micro Link", href: "#", size: :micro)
  end

  # @group With Icons
  # @label Basic Icon
  def icon_basic
    render ::Decor::ButtonLink.new(label: "Link with icon", href: "#", icon: "star")
  end

  # @group With Icons
  # @label Large with Icon
  def icon_large
    render ::Decor::ButtonLink.new(label: "Large with icon", href: "#", icon: "heart", size: :large)
  end

  # @group With Icons
  # @label Small with Icon
  def icon_small
    render ::Decor::ButtonLink.new(label: "Small with icon", href: "#", icon: "bell", size: :small)
  end

  # @group Disabled States
  # @label Disabled Primary (renders as button)
  def disabled_primary
    render ::Decor::ButtonLink.new(label: "Disabled Primary", href: "#", theme: :primary, disabled: true)
  end

  # @group Disabled States
  # @label Disabled Secondary (renders as button)
  def disabled_secondary
    render ::Decor::ButtonLink.new(label: "Disabled Secondary", href: "#", theme: :secondary, disabled: true)
  end

  # @group Disabled States
  # @label Disabled Danger (renders as button)
  def disabled_danger
    render ::Decor::ButtonLink.new(label: "Disabled Danger", href: "#", theme: :danger, disabled: true)
  end

  # @group HTTP Methods
  # @label GET Request
  def http_get
    render ::Decor::ButtonLink.new(label: "GET request", href: "/get-data", http_method: :get)
  end

  # @group HTTP Methods
  # @label POST Request
  def http_post
    render ::Decor::ButtonLink.new(label: "POST request", href: "/create-item", http_method: :post, theme: :primary)
  end

  # @group HTTP Methods
  # @label DELETE Request
  def http_delete
    render ::Decor::ButtonLink.new(label: "DELETE request", href: "/delete-item", http_method: :delete, theme: :danger)
  end

  # @group HTTP Methods
  # @label PATCH Request
  def http_patch
    render ::Decor::ButtonLink.new(label: "PATCH request", href: "/update-item", http_method: :patch, theme: :secondary)
  end

  # @group Turbo Features
  # @label Turbo Frame
  def turbo_frame
    render ::Decor::ButtonLink.new(label: "Load in modal", href: "/modal-content", turbo_frame: "modal")
  end

  # @group Turbo Features
  # @label Turbo Confirm
  def turbo_confirm
    render ::Decor::ButtonLink.new(
      label: "Delete with confirmation",
      href: "/dangerous-action",
      http_method: :delete,
      turbo_confirm: "Are you sure?",
      theme: :danger
    )
  end

  # @group Turbo Features
  # @label Disable Turbo
  def turbo_disabled
    render ::Decor::ButtonLink.new(
      label: "Full page reload",
      href: "/full-reload",
      turbo: false
    )
  end

  # @group Layout
  # @label Full Width
  def layout_full_width
    render ::Decor::ButtonLink.new(label: "Full Width Link", href: "#", full_width: true)
  end

  # @group Layout
  # @label Full Width Large
  def layout_full_width_large
    render ::Decor::ButtonLink.new(label: "Full Width Large", href: "#", full_width: true, size: :large)
  end

  # @group External Links
  # @label External Website
  def external_website
    render ::Decor::ButtonLink.new(label: "External Link", href: "https://example.com", target: "_blank")
  end

  # @group External Links
  # @label Email Link
  def external_email
    render ::Decor::ButtonLink.new(label: "Email Link", href: "mailto:test@example.com", theme: :secondary)
  end

  # @group Combinations
  # @label Outlined Danger Delete
  def combo_outlined_danger_delete
    render ::Decor::ButtonLink.new(
      label: "Delete Item",
      href: "/delete",
      variant: :outlined,
      theme: :danger,
      http_method: :delete,
      icon: "x"
    )
  end

  # @group Combinations
  # @label Text Primary with Icon
  def combo_text_primary_icon
    render ::Decor::ButtonLink.new(
      label: "Download File",
      href: "/download",
      variant: :text,
      theme: :primary,
      icon: "download"
    )
  end
end
