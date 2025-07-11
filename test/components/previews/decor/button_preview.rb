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
  # @param variant select [contained, outlined, text]
  # @param color select [primary, secondary, danger, warning, neutral]
  # @param element_tag select [button, a]
  # @param size select [medium, large, wide, small, micro, xs, lg, md, sm]
  # @param full_width toggle
  def playground(
    label: "Button",
    icon: nil,
    variant: :contained,
    color: :primary,
    size: :medium,
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
  # @label Danger Theme
  def theme_danger
    render ::Decor::Button.new(label: "Danger Button", color: :danger)
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
  # @label Contained Variant
  def variant_contained
    render ::Decor::Button.new(label: "Contained Button", variant: :contained)
  end

  # @group Variants
  # @label Outlined Variant
  def variant_outlined
    render ::Decor::Button.new(label: "Outlined Button", variant: :outlined)
  end

  # @group Variants
  # @label Text Variant
  def variant_text
    render ::Decor::Button.new(label: "Text Button", variant: :text)
  end

  # @group Sizes
  # @label Large Size
  def size_large
    render ::Decor::Button.new(label: "Large Button", size: :large)
  end

  # @group Sizes
  # @label Medium Size
  def size_medium
    render ::Decor::Button.new(label: "Medium Button", size: :medium)
  end

  # @group Sizes
  # @label Wide Size
  def size_wide
    render ::Decor::Button.new(label: "Wide Button", size: :wide)
  end

  # @group Sizes
  # @label Small Size
  def size_small
    render ::Decor::Button.new(label: "Small Button", size: :small)
  end

  # @group Sizes
  # @label Micro Size
  def size_micro
    render ::Decor::Button.new(label: "Micro Button", size: :micro)
  end

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
    render ::Decor::Button.new(label: "Large with icon", icon: "heart", size: :large)
  end

  # @group With Icons
  # @label Small with Icon
  def icon_small
    render ::Decor::Button.new(label: "Small with icon", icon: "bell", size: :small)
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
  # @label Disabled Danger
  def state_disabled_danger
    render ::Decor::Button.new(label: "Disabled Danger", color: :danger, disabled: true)
  end

  # @group Layout
  # @label Full Width
  def layout_full_width
    render ::Decor::Button.new(label: "Full Width Button", full_width: true)
  end

  # @group Layout
  # @label Full Width Large
  def layout_full_width_large
    render ::Decor::Button.new(label: "Full Width Large", full_width: true, size: :large)
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
      variant: :outlined,
      color: :primary,
      size: :large
    )
  end

  # @group Combinations
  # @label Text Danger with Icon
  def combo_text_danger_icon
    render ::Decor::Button.new(
      label: "Delete Item",
      variant: :text,
      color: :danger,
      icon: "x"
    )
  end

  # @group Combinations
  # @label Wide Secondary Outlined
  def combo_wide_secondary_outlined
    render ::Decor::Button.new(
      label: "Wide Secondary",
      variant: :outlined,
      color: :secondary,
      size: :wide
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
