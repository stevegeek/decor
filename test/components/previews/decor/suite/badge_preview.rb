# @label Badge
class ::Decor::Suite::BadgePreview < ::Lookbook::Preview
  # Badge (Suite)
  # -------------
  #
  # Pill-shaped status/classification chip with a muted palette and an optional
  # animated halo dot. Use for state ("Active", "Pending"), classification
  # ("Premium"), or short label noise. For user-applied labels or entity names
  # use Tag.

  # @group Playground
  # @param label text
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined]
  # @param dot toggle
  # @param icon select [~, star, heart, check, bookmark, tag]
  def playground(label: "Active", size: nil, color: nil, style: nil, dot: false, icon: nil)
    render ::Decor::Suite::Badge.new(
      label: label,
      size: size,
      color: color,
      style: style,
      dot: dot,
      icon: icon
    )
  end

  # @group Default
  def default
    render ::Decor::Suite::Badge.new(label: "Default")
  end

  # @group Colors (filled)
  # @label Primary
  def color_primary
    render ::Decor::Suite::Badge.new(label: "Primary", color: :primary)
  end

  # @group Colors (filled)
  # @label Success
  def color_success
    render ::Decor::Suite::Badge.new(label: "Success", color: :success)
  end

  # @group Colors (filled)
  # @label Warning
  def color_warning
    render ::Decor::Suite::Badge.new(label: "Warning", color: :warning)
  end

  # @group Colors (filled)
  # @label Error
  def color_error
    render ::Decor::Suite::Badge.new(label: "Error", color: :error)
  end

  # @group Colors (filled)
  # @label Info
  def color_info
    render ::Decor::Suite::Badge.new(label: "Info", color: :info)
  end

  # @group Colors (filled)
  # @label Neutral
  def color_neutral
    render ::Decor::Suite::Badge.new(label: "Neutral", color: :neutral)
  end

  # @group Outlined
  # @label Primary (outlined)
  def outlined_primary
    render ::Decor::Suite::Badge.new(label: "Primary", color: :primary, style: :outlined)
  end

  # @group Outlined
  # @label Success (outlined)
  def outlined_success
    render ::Decor::Suite::Badge.new(label: "Success", color: :success, style: :outlined)
  end

  # @group Outlined
  # @label Warning (outlined)
  def outlined_warning
    render ::Decor::Suite::Badge.new(label: "Warning", color: :warning, style: :outlined)
  end

  # @group Outlined
  # @label Error (outlined)
  def outlined_error
    render ::Decor::Suite::Badge.new(label: "Error", color: :error, style: :outlined)
  end

  # @group Outlined
  # @label Info (outlined)
  def outlined_info
    render ::Decor::Suite::Badge.new(label: "Info", color: :info, style: :outlined)
  end

  # @group Outlined
  # @label Neutral (outlined)
  def outlined_neutral
    render ::Decor::Suite::Badge.new(label: "Neutral", color: :neutral, style: :outlined)
  end

  # @group With Icon
  # @label Icon prefix
  def with_icon
    render ::Decor::Suite::Badge.new(label: "Featured", icon: "star", color: :success)
  end

  # @group With Dot
  # @label Dot prefix
  def with_dot
    render ::Decor::Suite::Badge.new(label: "Active", dot: true, color: :primary)
  end

  # @group Sizes
  # @label sm
  def size_sm
    render ::Decor::Suite::Badge.new(label: "Small", color: :primary, size: :sm)
  end

  # @group Sizes
  # @label md
  def size_md
    render ::Decor::Suite::Badge.new(label: "Medium", color: :primary, size: :md)
  end

  # @group Sizes
  # @label lg
  def size_lg
    render ::Decor::Suite::Badge.new(label: "Large", color: :primary, size: :lg)
  end
end
