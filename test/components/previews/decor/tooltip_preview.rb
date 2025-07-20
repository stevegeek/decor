# @label Tooltip
class ::Decor::TooltipPreview < ::Lookbook::Preview
  # Tooltips
  # --------
  #
  # A tooltip is a small popover that displays additional information about something
  # when the user hovers over it. Supports different positions, sizes, colors, and variants.
  #
  # @label Playground
  # @param tip_text text
  # @param position select [top, bottom, left, right]
  # @param size select [xs, sm, md, lg, xl]
  # @param color select [base, primary, secondary, accent, success, error, warning, info, neutral]
  # @param variant select [filled, outlined, ghost]
  def playground(
    tip_text: "This is helpful tooltip text",
    position: :top,
    size: :md,
    color: :base,
    variant: :filled
  )
    render ::Decor::Tooltip.new(
      tip_text: tip_text,
      position: position,
      size: size,
      color: color,
      variant: variant
    ) do |t|
      t.render ::Decor::Button.new(label: "Hover for tooltip")
    end
  end

  # @group Positions
  # @label Top Position
  def position_top
    render ::Decor::Tooltip.new(tip_text: "Top tooltip", position: :top) do
      render ::Decor::Button.new(label: "Top")
    end
  end

  # @group Positions
  # @label Bottom Position
  def position_bottom
    render ::Decor::Tooltip.new(tip_text: "Bottom tooltip", position: :bottom) do
      render ::Decor::Button.new(label: "Bottom")
    end
  end

  # @group Positions
  # @label Left Position
  def position_left
    render ::Decor::Tooltip.new(tip_text: "Left tooltip", position: :left) do
      render ::Decor::Button.new(label: "Left")
    end
  end

  # @group Positions
  # @label Right Position
  def position_right
    render ::Decor::Tooltip.new(tip_text: "Right tooltip", position: :right) do
      render ::Decor::Button.new(label: "Right")
    end
  end

  # @group Sizes
  # @label Extra Small Size
  def size_xs
    render ::Decor::Tooltip.new(tip_text: "Extra small tooltip", size: :xs) do
      render ::Decor::Button.new(label: "XS Tooltip", size: :small)
    end
  end

  # @group Sizes
  # @label Small Size
  def size_sm
    render ::Decor::Tooltip.new(tip_text: "Small tooltip", size: :sm) do
      render ::Decor::Button.new(label: "SM Tooltip", size: :small)
    end
  end

  # @group Sizes
  # @label Medium Size
  def size_md
    render ::Decor::Tooltip.new(tip_text: "Medium tooltip (default)", size: :md) do
      render ::Decor::Button.new(label: "MD Tooltip", size: :medium)
    end
  end

  # @group Sizes
  # @label Large Size
  def size_lg
    render ::Decor::Tooltip.new(tip_text: "Large tooltip", size: :lg) do
      render ::Decor::Button.new(label: "LG Tooltip", size: :large)
    end
  end

  # @group Sizes
  # @label Extra Large Size
  def size_xl
    render ::Decor::Tooltip.new(tip_text: "Extra large tooltip", size: :xl) do
      render ::Decor::Button.new(label: "XL Tooltip", size: :large)
    end
  end

  # @group Colors
  # @label Base Color
  def color_base
    render ::Decor::Tooltip.new(tip_text: "Base tooltip", color: :base) do
      render ::Decor::Button.new(label: "Base")
    end
  end

  # @group Colors
  # @label Primary Color
  def color_primary
    render ::Decor::Tooltip.new(tip_text: "Primary tooltip", color: :primary) do
      render ::Decor::Button.new(label: "Primary", color: :primary)
    end
  end

  # @group Colors
  # @label Secondary Color
  def color_secondary
    render ::Decor::Tooltip.new(tip_text: "Secondary tooltip", color: :secondary) do
      render ::Decor::Button.new(label: "Secondary", color: :secondary)
    end
  end

  # @group Colors
  # @label Accent Color
  def color_accent
    render ::Decor::Tooltip.new(tip_text: "Accent tooltip", color: :accent) do
      render ::Decor::Button.new(label: "Accent")
    end
  end

  # @group Colors
  # @label Success Color
  def color_success
    render ::Decor::Tooltip.new(tip_text: "Success tooltip", color: :success) do
      render ::Decor::Button.new(label: "Success")
    end
  end

  # @group Colors
  # @label Error Color
  def color_error
    render ::Decor::Tooltip.new(tip_text: "Error tooltip", color: :error) do
      render ::Decor::Button.new(label: "Error", color: :danger)
    end
  end

  # @group Colors
  # @label Warning Color
  def color_warning
    render ::Decor::Tooltip.new(tip_text: "Warning tooltip", color: :warning) do
      render ::Decor::Button.new(label: "Warning", color: :warning)
    end
  end

  # @group Colors
  # @label Info Color
  def color_info
    render ::Decor::Tooltip.new(tip_text: "Info tooltip", color: :info) do
      render ::Decor::Button.new(label: "Info")
    end
  end

  # @group Colors
  # @label Neutral Color
  def color_neutral
    render ::Decor::Tooltip.new(tip_text: "Neutral tooltip", color: :neutral) do
      render ::Decor::Button.new(label: "Neutral", color: :neutral)
    end
  end

  # @group Variants
  # @label Filled Variant
  def variant_filled
    render ::Decor::Tooltip.new(tip_text: "Filled tooltip (default)", variant: :filled) do
      render ::Decor::Button.new(label: "Filled")
    end
  end

  # @group Variants
  # @label Outlined Variant
  def variant_outlined
    render ::Decor::Tooltip.new(tip_text: "Outlined tooltip", variant: :outlined) do
      render ::Decor::Button.new(label: "Outlined", variant: :outlined)
    end
  end

  # @group Variants
  # @label Ghost Variant
  def variant_ghost
    render ::Decor::Tooltip.new(tip_text: "Ghost tooltip", variant: :ghost) do
      render ::Decor::Button.new(label: "Ghost", variant: :text)
    end
  end

  # @group With Offsets
  # @label Custom X Offset
  def offset_x_custom
    render ::Decor::Tooltip.new(tip_text: "Custom X offset", offset_percent_x: 100) do
      render ::Decor::Button.new(label: "Custom X Offset")
    end
  end

  # @group With Offsets
  # @label Custom Y Offset
  def offset_y_custom
    render ::Decor::Tooltip.new(tip_text: "Custom Y offset", offset_percent_y: 150) do
      render ::Decor::Button.new(label: "Custom Y Offset")
    end
  end

  # @group Combinations
  # @label Large Primary Left
  def combo_large_primary_left
    render ::Decor::Tooltip.new(
      tip_text: "Large primary tooltip on left",
      size: :lg,
      color: :primary,
      position: :left
    ) do
      render ::Decor::Button.new(label: "Large Primary Left", color: :primary, size: :large)
    end
  end

  # @group Combinations
  # @label Small Error Bottom
  def combo_small_error_bottom
    render ::Decor::Tooltip.new(
      tip_text: "Small error tooltip at bottom",
      size: :sm,
      color: :error,
      position: :bottom
    ) do
      render ::Decor::Button.new(label: "Small Error Bottom", color: :danger, size: :small)
    end
  end

  # @group Combinations
  # @label Ghost Warning Right
  def combo_ghost_warning_right
    render ::Decor::Tooltip.new(
      tip_text: "Ghost warning tooltip on right",
      variant: :ghost,
      color: :warning,
      position: :right
    ) do
      render ::Decor::Button.new(label: "Ghost Warning Right", variant: :text, color: :warning)
    end
  end
end
