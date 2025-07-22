# @label ButtonLink
class ::Decor::ButtonLinkPreview < ::Lookbook::Preview
  # ButtonLinks
  # -------
  #
  # A button that is rendered with a link tag when enabled, or as a button when disabled.
  # Supports all Button styling with ActsAsLink functionality.

  # @group Examples
  # @label Outlined Danger Delete
  def combo_outlined_danger_delete
    render ::Decor::ButtonLink.new(
      label: "Delete Item",
      href: "/delete",
      style: :outlined,
      color: :error,
      http_method: :delete,
      icon: "x"
    )
  end

  # @group Examples
  # @label Text Primary with Icon
  def combo_text_primary_icon
    render ::Decor::ButtonLink.new(
      label: "Download File",
      href: "/download",
      style: :ghost,
      color: :primary,
      icon: "download"
    )
  end

  # @group Playground
  # @param label text
  # @param href text
  # @param http_method select [~, get, post, put, patch, delete]
  # @param disabled toggle
  # @param icon select [~, check-circle, x, check, download, play]
  # @param full_width toggle
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  def playground(
    label: "Button Link",
    href: "https://www.google.com",
    http_method: :get,
    icon: nil,
    disabled: false,
    full_width: false,
    size: nil,
    color: nil,
    style: nil
  )
    render ::Decor::ButtonLink.new(
      label: label,
      href: href,
      http_method: http_method,
      icon: icon,
      disabled: disabled,
      full_width: full_width,
      size: size,
      color: color,
      style: style
    )
  end

  # @group Themes
  # @label Primary Theme
  def theme_primary
    render ::Decor::ButtonLink.new(label: "Primary Link", href: "#", color: :primary)
  end

  # @group Themes
  # @label Secondary Theme
  def theme_secondary
    render ::Decor::ButtonLink.new(label: "Secondary Link", href: "#", color: :secondary)
  end

  # @group Themes
  # @label Error Theme
  def theme_error
    render ::Decor::ButtonLink.new(label: "Error Link", href: "#", color: :error)
  end

  # @group Themes
  # @label Warning Theme
  def theme_warning
    render ::Decor::ButtonLink.new(label: "Warning Link", href: "#", color: :warning)
  end

  # @group Themes
  # @label Neutral Theme
  def theme_neutral
    render ::Decor::ButtonLink.new(label: "Neutral Link", href: "#", color: :neutral)
  end

  # @group Styles
  # @label Filled Style
  def style_filled
    render ::Decor::ButtonLink.new(label: "Filled Link", href: "#", style: :filled)
  end

  # @group Styles
  # @label Outlined Style
  def style_outlined
    render ::Decor::ButtonLink.new(label: "Outlined Link", href: "#", style: :outlined)
  end

  # @group Styles
  # @label Ghost Style
  def style_ghost
    render ::Decor::ButtonLink.new(label: "Ghost Link", href: "#", style: :ghost)
  end

  # @group Sizes
  # @label Large Size
  def size_large
    render ::Decor::ButtonLink.new(label: "Large Link", href: "#", size: :lg)
  end

  # @group Sizes
  # @label Medium Size
  def size_medium
    render ::Decor::ButtonLink.new(label: "Medium Link", href: "#", size: :md)
  end

  # @group Sizes
  # @label Extra Large Size
  def size_xl
    render ::Decor::ButtonLink.new(label: "XL Link", href: "#", size: :xl)
  end

  # @group Sizes
  # @label Small Size
  def size_small
    render ::Decor::ButtonLink.new(label: "Small Link", href: "#", size: :sm)
  end

  # @group Sizes
  # @label Extra Small Size
  def size_xs
    render ::Decor::ButtonLink.new(label: "XS Link", href: "#", size: :xs)
  end

  # @group With Icons
  # @label Basic Icon
  def icon_basic
    render ::Decor::ButtonLink.new(label: "Link with icon", href: "#", icon: "star")
  end

  # @group With Icons
  # @label Large with Icon
  def icon_large
    render ::Decor::ButtonLink.new(label: "Large with icon", href: "#", icon: "heart", size: :lg)
  end

  # @group With Icons
  # @label Small with Icon
  def icon_small
    render ::Decor::ButtonLink.new(label: "Small with icon", href: "#", icon: "bell", size: :sm)
  end

  # @group Disabled States
  # @label Disabled Primary (renders as button)
  def disabled_primary
    render ::Decor::ButtonLink.new(label: "Disabled Primary", href: "#", color: :primary, disabled: true)
  end

  # @group Disabled States
  # @label Disabled Secondary (renders as button)
  def disabled_secondary
    render ::Decor::ButtonLink.new(label: "Disabled Secondary", href: "#", color: :secondary, disabled: true)
  end

  # @group Disabled States
  # @label Disabled Error (renders as button)
  def disabled_error
    render ::Decor::ButtonLink.new(label: "Disabled Error", href: "#", color: :error, disabled: true)
  end

  # @group HTTP Methods
  # @label GET Request
  def http_get
    render ::Decor::ButtonLink.new(label: "GET request", href: "/get-data", http_method: :get)
  end

  # @group HTTP Methods
  # @label POST Request
  def http_post
    render ::Decor::ButtonLink.new(label: "POST request", href: "/create-item", http_method: :post, color: :primary)
  end

  # @group HTTP Methods
  # @label DELETE Request
  def http_delete
    render ::Decor::ButtonLink.new(label: "DELETE request", href: "/delete-item", http_method: :delete, color: :error)
  end

  # @group HTTP Methods
  # @label PATCH Request
  def http_patch
    render ::Decor::ButtonLink.new(label: "PATCH request", href: "/update-item", http_method: :patch, color: :secondary)
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
      color: :error
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
    render ::Decor::ButtonLink.new(label: "Full Width Large", href: "#", full_width: true, size: :lg)
  end

  # @group External Links
  # @label External Website
  def external_website
    render ::Decor::ButtonLink.new(label: "External Link", href: "https://example.com", target: "_blank")
  end

  # @group External Links
  # @label Email Link
  def external_email
    render ::Decor::ButtonLink.new(label: "Email Link", href: "mailto:test@example.com", color: :secondary)
  end
end
