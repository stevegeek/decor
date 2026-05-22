# @label Button
class ::Decor::Suite::ButtonPreview < ::Lookbook::Preview
  # Button (Suite)
  # --------------
  #
  # Filled / outlined / ghost button with Stripe-style bevelled shadow on
  # filled variants. Sizes follow the standard scale plus Suite-specific
  # `:wide` (extra horizontal padding) and `:link` (inline underlined text).
  # `loading: true` overlays a spinner and hides the label while preserving
  # the button's width.

  # @group Playground
  # @param label text
  # @param size [Symbol] select [~, xs, sm, md, lg, xl, wide, link]
  # @param color [Symbol] select [~, base, primary, error, warning]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  # @param icon select [~, star, heart, check, bookmark, plus]
  # @param disabled toggle
  # @param loading toggle
  # @param full_width toggle
  # @param icon_only_on_mobile toggle
  def playground(label: "Save changes", size: nil, color: nil, style: nil, icon: nil, disabled: false, loading: false, full_width: false, icon_only_on_mobile: false)
    render ::Decor::Suite::Button.new(
      label: label,
      size: size,
      color: color,
      style: style,
      icon: icon,
      disabled: disabled,
      loading: loading,
      full_width: full_width,
      icon_only_on_mobile: icon_only_on_mobile
    )
  end

  # @group Default
  def default
    render ::Decor::Suite::Button.new(label: "Save changes")
  end

  # @group Colors (filled)
  # @label Primary
  def color_primary
    render ::Decor::Suite::Button.new(label: "Save", color: :primary)
  end

  # @group Colors (filled)
  # @label Error
  def color_error
    render ::Decor::Suite::Button.new(label: "Delete", color: :error)
  end

  # @group Colors (filled)
  # @label Warning
  def color_warning
    render ::Decor::Suite::Button.new(label: "Proceed", color: :warning)
  end

  # @group Colors (filled)
  # @label Base
  def color_base
    render ::Decor::Suite::Button.new(label: "Cancel", color: :base)
  end

  # @group Outlined
  # @label Primary (outlined)
  def outlined_primary
    render ::Decor::Suite::Button.new(label: "Save", color: :primary, style: :outlined)
  end

  # @group Outlined
  # @label Error (outlined)
  def outlined_error
    render ::Decor::Suite::Button.new(label: "Delete", color: :error, style: :outlined)
  end

  # @group Outlined
  # @label Base (outlined)
  def outlined_base
    render ::Decor::Suite::Button.new(label: "Cancel", color: :base, style: :outlined)
  end

  # @group Ghost
  # @label Primary (ghost)
  def ghost_primary
    render ::Decor::Suite::Button.new(label: "Edit", color: :primary, style: :ghost)
  end

  # @group Ghost
  # @label Error (ghost)
  def ghost_error
    render ::Decor::Suite::Button.new(label: "Remove", color: :error, style: :ghost)
  end

  # @group Ghost
  # @label Base (ghost)
  def ghost_base
    render ::Decor::Suite::Button.new(label: "Skip", color: :base, style: :ghost)
  end

  # @group Sizes
  # @label xs
  def size_xs
    render ::Decor::Suite::Button.new(label: "Extra small", size: :xs)
  end

  # @group Sizes
  # @label sm
  def size_sm
    render ::Decor::Suite::Button.new(label: "Small", size: :sm)
  end

  # @group Sizes
  # @label md
  def size_md
    render ::Decor::Suite::Button.new(label: "Medium", size: :md)
  end

  # @group Sizes
  # @label lg
  def size_lg
    render ::Decor::Suite::Button.new(label: "Large", size: :lg)
  end

  # @group Sizes
  # @label wide
  def size_wide
    render ::Decor::Suite::Button.new(label: "Wide CTA", size: :wide)
  end

  # @group Sizes
  # @label link
  def size_link
    render ::Decor::Suite::Button.new(label: "Inline link", size: :link)
  end

  # @group With Icon
  # @label Icon + label
  def with_icon
    render ::Decor::Suite::Button.new(label: "Add item", icon: "plus")
  end

  # @group With Icon
  # @label Icon hidden on mobile
  def icon_only_on_mobile
    render ::Decor::Suite::Button.new(label: "Filters", icon: "filter", icon_only_on_mobile: true)
  end

  # @group States
  # @label Disabled
  def state_disabled
    render ::Decor::Suite::Button.new(label: "Save", disabled: true)
  end

  # @group States
  # @label Loading
  def state_loading
    render ::Decor::Suite::Button.new(label: "Saving…", loading: true)
  end

  # @group States
  # @label Full width
  def state_full_width
    render ::Decor::Suite::Button.new(label: "Continue", full_width: true)
  end
end
