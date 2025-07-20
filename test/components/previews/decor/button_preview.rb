# @label Button
class ::Decor::ButtonPreview < ::Lookbook::Preview
  # Buttons
  # -------
  #
  # A styled button component with daisyUI styling.
  # Supports different themes, variants, sizes, and states.
  #
  # @label Playground
  # @param label text
  # @param disabled toggle
  # @param icon select [~, check-circle, x, check, download, play]
  # @param style select [filled, outlined, ghost]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param element_tag select [button, a]
  # @param size select [xs, sm, md, lg, xl]
  # @param full_width toggle
  def playground(
    label: "Button",
    icon: nil,
    style: :filled,
    color: nil,
    size: :md,
    element_tag: :button,
    disabled: false,
    full_width: false
  )
    render ::Decor::Button.new(
      label: label,
      icon: icon,
      variant: variant,
      color: color,
      size: size,
      element_tag: element_tag,
      disabled: disabled,
      full_width: full_width
    )
  end

  # @group Colors
  # @label Primary Theme
  def theme_primary
    render ::Decor::Button.new(label: "Primary Button", color: :primary)
  end

  # @group Colors
  # @label Secondary Theme
  def theme_secondary
    render ::Decor::Button.new(label: "Secondary Button", color: :secondary)
  end

  # @group Colors
  # @label Error Theme
  def theme_error
    render ::Decor::Button.new(label: "Error Button", color: :error)
  end

  # @group Colors
  # @label Warning Theme
  def theme_warning
    render ::Decor::Button.new(label: "Warning Button", color: :warning)
  end

  # @group Colors
  # @label Neutral Theme
  def theme_neutral
    render ::Decor::Button.new(label: "Neutral Button", color: :neutral)
  end

  # @group Variants
  # @label Filled Variant
  def variant_filled
    render ::Decor::Button.new(label: "Filled Button", variant: :filled)
  end

  # @group Variants
  # @label Outlined Variant
  def variant_outlined
    render ::Decor::Button.new(label: "Outlined Button", variant: :outlined)
  end

  # @group Variants
  # @label Ghost Variant
  def variant_ghost
    render ::Decor::Button.new(label: "Ghost Button", variant: :ghost)
  end

  # @group Sizes
  # @label Large Size
  def size_large
    render ::Decor::Button.new(label: "Large Button", size: :lg)
  end

  # @group Sizes
  # @label Medium Size
  def size_medium
    render ::Decor::Button.new(label: "Medium Button", size: :md)
  end

  # @group Sizes
  # @label Extra Large Size
  def size_xl
    render ::Decor::Button.new(label: "Extra Large Button", size: :xl)
  end

  # @group Sizes
  # @label Small Size
  def size_small
    render ::Decor::Button.new(label: "Small Button", size: :sm)
  end

  # @group Sizes

  # @group Sizes
  # @label XS Size (alias for micro)
  def size_xs
    render ::Decor::Button.new(label: "XS Button", size: :xs)
  end

  # @group Size Aliases
  # @label Large Alias (lg)
  def size_alias_lg
    render ::Decor::Button.new(label: "Large Alias", size: :lg)
  end

  # @group Size Aliases
  # @label Medium Alias (md)
  def size_alias_md
    render ::Decor::Button.new(label: "Medium Alias", size: :md)
  end

  # @group Size Aliases
  # @label Small Alias (sm)
  def size_alias_sm
    render ::Decor::Button.new(label: "Small Alias", size: :sm)
  end

  # @group With Icons
  # @label Basic Icon
  def icon_basic
    render ::Decor::Button.new(label: "Button with icon", icon: "star")
  end

  # @group With Icons
  # @label Large with Icon
  def icon_large
    render ::Decor::Button.new(label: "Large with icon", icon: "heart", size: :lg)
  end

  # @group With Icons
  # @label Small with Icon
  def icon_small
    render ::Decor::Button.new(label: "Small with icon", icon: "bell", size: :sm)
  end

  # @group With Icons
  # @label Icon Only Mobile
  def icon_only_mobile
    render ::Decor::Button.new(label: "Submit", icon: "check", icon_only_on_mobile: true)
  end

  # @group States
  # @label Disabled Primary
  def state_disabled_primary
    render ::Decor::Button.new(label: "Disabled Primary", color: :primary, disabled: true)
  end

  # @group States
  # @label Disabled Secondary
  def state_disabled_secondary
    render ::Decor::Button.new(label: "Disabled Secondary", color: :secondary, disabled: true)
  end

  # @group States
  # @label Disabled Error
  def state_disabled_error
    render ::Decor::Button.new(label: "Disabled Error", color: :error, disabled: true)
  end

  # @group Layout
  # @label Full Width
  def layout_full_width
    render ::Decor::Button.new(label: "Full Width Button", full_width: true)
  end

  # @group Layout
  # @label Full Width Large
  def layout_full_width_large
    render ::Decor::Button.new(label: "Full Width Large", full_width: true, size: :lg)
  end

  # @group Layout
  # @label Full Width with Icon
  def layout_full_width_icon
    render ::Decor::Button.new(label: "Full Width with Icon", full_width: true, icon: "download")
  end

  # @group Combinations
  # @label Outlined Primary Large
  def combo_outlined_primary_large
    render ::Decor::Button.new(
      label: "Outlined Primary Large",
      style: :outlined,
      color: :primary,
      size: :lg
    )
  end

  # @group Combinations
  # @label Ghost Error with Icon
  def combo_ghost_error_icon
    render ::Decor::Button.new(
      label: "Delete Item",
      style: :ghost,
      color: :error,
      icon: "x"
    )
  end

  # @group Combinations
  # @label Large Secondary Outlined
  def combo_large_secondary_outlined
    render ::Decor::Button.new(
      label: "Large Secondary",
      style: :outlined,
      color: :secondary,
      size: :lg
    )
  end

  # @group Element Types
  # @label As Button Element
  def element_button
    render ::Decor::Button.new(label: "Button Element", element_tag: :button)
  end

  # @group Element Types
  # @label As Anchor Element
  def element_anchor
    render ::Decor::Button.new(label: "Anchor Element", element_tag: :a)
  end
end
