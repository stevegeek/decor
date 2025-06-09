# @label Button
class ::Decor::ButtonPreview < ::ViewComponent::Preview
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
  # @param theme select [primary, secondary, danger, warning, neutral]
  # @param element_tag select [button, a]
  # @param size select [medium, large, wide, small, micro]
  # @param full_width toggle
  def playground(
    label: "Button",
    icon: nil,
    variant: :contained,
    theme: :primary,
    size: :medium,
    element_tag: :button,
    disabled: false,
    full_width: false
  )
    render ::Decor::Button.new(
      label: label,
      icon: icon,
      variant: variant,
      theme: theme,
      size: size,
      element_tag: element_tag,
      disabled: disabled,
      full_width: full_width
    )
  end

  # @group Themes
  # @label Primary Theme
  def theme_primary
    render ::Decor::Button.new(label: "Primary Button", theme: :primary)
  end

  # @group Themes
  # @label Secondary Theme
  def theme_secondary
    render ::Decor::Button.new(label: "Secondary Button", theme: :secondary)
  end

  # @group Themes
  # @label Danger Theme
  def theme_danger
    render ::Decor::Button.new(label: "Danger Button", theme: :danger)
  end

  # @group Themes
  # @label Warning Theme
  def theme_warning
    render ::Decor::Button.new(label: "Warning Button", theme: :warning)
  end

  # @group Themes
  # @label Neutral Theme
  def theme_neutral
    render ::Decor::Button.new(label: "Neutral Button", theme: :neutral)
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
    render ::Decor::Button.new(label: "Disabled Primary", theme: :primary, disabled: true)
  end

  # @group States
  # @label Disabled Secondary
  def state_disabled_secondary
    render ::Decor::Button.new(label: "Disabled Secondary", theme: :secondary, disabled: true)
  end

  # @group States
  # @label Disabled Danger
  def state_disabled_danger
    render ::Decor::Button.new(label: "Disabled Danger", theme: :danger, disabled: true)
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
      theme: :primary,
      size: :large
    )
  end

  # @group Combinations
  # @label Text Danger with Icon
  def combo_text_danger_icon
    render ::Decor::Button.new(
      label: "Delete Item",
      variant: :text,
      theme: :danger,
      icon: "x"
    )
  end

  # @group Combinations
  # @label Wide Secondary Outlined
  def combo_wide_secondary_outlined
    render ::Decor::Button.new(
      label: "Wide Secondary",
      variant: :outlined,
      theme: :secondary,
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
