# @label Link
class ::Decor::LinkPreview < ::Lookbook::Preview
  # Link
  # -------
  #
  # A styled anchor link component with daisyUI btn-link styling.
  # Supports different themes for color, sizes, and disabled state.
  #
  # @group Examples
  # @label Simple Link
  def simple_link
    render ::Decor::Link.new(
      label: "Learn more",
      href: "/about"
    )
  end

  # @group Examples
  # @label Navigation Link
  def navigation_link
    render ::Decor::Link.new(
      label: "Dashboard",
      href: "/dashboard",
      icon: "home",
      color: :primary
    )
  end

  # @group Examples
  # @label Download Link
  def download_link
    render ::Decor::Link.new(
      label: "Download Report",
      href: "/reports/annual.pdf",
      icon: "download",
      color: :accent,
      data: {turbo: false}
    )
  end

  # @group Examples
  # @label Action Links
  def action_links
    render_with_template(
      locals: {
        links: [
          ::Decor::Link.new(label: "Edit", href: "/edit", icon: "pencil", color: :primary, size: :sm),
          ::Decor::Link.new(label: "Delete", href: "/delete", icon: "trash", color: :error, size: :sm, http_method: :delete, turbo_confirm: "Are you sure?"),
          ::Decor::Link.new(label: "Archive", href: "/archive", icon: "archive-box", color: :neutral, size: :sm)
        ]
      }
    )
  end

  # @group Playground
  # @param label text
  # @param href text
  # @param icon select [~, check-circle, x, check, download, play]
  # @param disabled toggle
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  def playground(label: "Click me", href: "#", icon: nil, disabled: false, size: nil, color: nil, style: nil)
    render ::Decor::Link.new(
      label: label,
      href: href,
      icon: icon,
      disabled: disabled,
      size: size,
      color: color,
      style: style
    )
  end

  # @group Themes
  # @label Primary Theme
  def theme_primary
    render ::Decor::Link.new(label: "Primary Link", href: "#", color: :primary)
  end

  # @group Themes
  # @label Secondary Theme
  def theme_secondary
    render ::Decor::Link.new(label: "Secondary Link", href: "#", color: :secondary)
  end

  # @group Themes
  # @label Error Theme
  def theme_error
    render ::Decor::Link.new(label: "Error Link", href: "#", color: :error)
  end

  # @group Themes
  # @label Warning Theme
  def theme_warning
    render ::Decor::Link.new(label: "Warning Link", href: "#", color: :warning)
  end

  # @group Themes
  # @label Neutral Theme
  def theme_neutral
    render ::Decor::Link.new(label: "Neutral Link", href: "#", color: :neutral)
  end

  # @group Sizes
  # @label Large Size
  def size_large
    render ::Decor::Link.new(label: "Large Link", href: "#", size: :lg)
  end

  # @group Sizes
  # @label Medium Size
  def size_medium
    render ::Decor::Link.new(label: "Medium Link", href: "#", size: :md)
  end

  # @group Sizes
  # @label Small Size
  def size_small
    render ::Decor::Link.new(label: "Small Link", href: "#", size: :sm)
  end

  # @group Sizes
  # @label Extra Small Size
  def size_xs
    render ::Decor::Link.new(label: "XS Link", href: "#", size: :xs)
  end

  # @group With Icons
  # @label Basic Icon
  def icon_basic
    render ::Decor::Link.new(label: "Link with icon", href: "#", icon: "star")
  end

  # @group With Icons
  # @label Large with Icon
  def icon_large
    render ::Decor::Link.new(label: "Large with icon", href: "#", icon: "heart", size: :lg)
  end

  # @group With Icons
  # @label Small with Icon
  def icon_small
    render ::Decor::Link.new(label: "Small with icon", href: "#", icon: "bell", size: :sm)
  end

  # @group Disabled States
  # @label Disabled Primary
  def disabled_primary
    render ::Decor::Link.new(label: "Disabled Primary", href: "#", color: :primary, disabled: true)
  end

  # @group Disabled States
  # @label Disabled Secondary
  def disabled_secondary
    render ::Decor::Link.new(label: "Disabled Secondary", href: "#", color: :secondary, disabled: true)
  end

  # @group Disabled States
  # @label Disabled Error
  def disabled_error
    render ::Decor::Link.new(label: "Disabled Error", href: "#", color: :error, disabled: true)
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
    render ::Decor::Link.new(label: "DELETE request", href: "/delete-item", http_method: :delete, color: :error)
  end

  # @group Turbo Methods
  # @label POST Request
  def turbo_post
    render ::Decor::Link.new(label: "POST request", href: "/create-item", http_method: :post, color: :primary)
  end

  # @group Turbo Methods
  # @label PATCH Request
  def turbo_patch
    render ::Decor::Link.new(label: "PATCH request", href: "/update-item", http_method: :patch, color: :secondary)
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
      color: :error
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
