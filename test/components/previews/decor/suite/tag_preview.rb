# @label Tag
class ::Decor::Suite::TagPreview < ::Lookbook::Preview
  # Tag (Suite)
  # -----------
  #
  # Pointed-nose tag silhouette with an optional animated LED indicator.
  # Use for user-applied labels, tag-entity names, brand/category names.
  # For state, classification, or counts use Badge.

  # @group Playground
  # @param label text
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined]
  # @param led toggle
  # @param icon select [~, star, heart, check, bookmark, tag]
  # @param removable toggle
  def playground(label: "Featured", size: nil, color: nil, style: nil, led: true, icon: nil, removable: false)
    render ::Decor::Suite::Tag.new(
      label: label,
      size: size,
      color: color,
      style: style,
      led: led,
      icon: icon,
      removable: removable
    )
  end

  # @group Colors (filled)
  # @label Primary
  def color_primary
    render ::Decor::Suite::Tag.new(label: "Primary", color: :primary)
  end

  # @group Colors (filled)
  # @label Success
  def color_success
    render ::Decor::Suite::Tag.new(label: "Success", color: :success)
  end

  # @group Colors (filled)
  # @label Warning
  def color_warning
    render ::Decor::Suite::Tag.new(label: "Warning", color: :warning)
  end

  # @group Colors (filled)
  # @label Error
  def color_error
    render ::Decor::Suite::Tag.new(label: "Error", color: :error)
  end

  # @group Colors (filled)
  # @label Info
  def color_info
    render ::Decor::Suite::Tag.new(label: "Info", color: :info)
  end

  # @group Colors (filled)
  # @label Neutral
  def color_neutral
    render ::Decor::Suite::Tag.new(label: "Neutral", color: :neutral)
  end

  # @group Outlined
  # @label Primary (outlined)
  def outlined_primary
    render ::Decor::Suite::Tag.new(label: "Primary", color: :primary, style: :outlined)
  end

  # @group Outlined
  # @label Success (outlined)
  def outlined_success
    render ::Decor::Suite::Tag.new(label: "Success", color: :success, style: :outlined)
  end

  # @group Outlined
  # @label Warning (outlined)
  def outlined_warning
    render ::Decor::Suite::Tag.new(label: "Warning", color: :warning, style: :outlined)
  end

  # @group Outlined
  # @label Error (outlined)
  def outlined_error
    render ::Decor::Suite::Tag.new(label: "Error", color: :error, style: :outlined)
  end

  # @group Outlined
  # @label Info (outlined)
  def outlined_info
    render ::Decor::Suite::Tag.new(label: "Info", color: :info, style: :outlined)
  end

  # @group Outlined
  # @label Neutral (outlined)
  def outlined_neutral
    render ::Decor::Suite::Tag.new(label: "Neutral", color: :neutral, style: :outlined)
  end

  # @group Removable
  # @label Removable
  def removable_tag
    render ::Decor::Suite::Tag.new(label: "Beverages", removable: true)
  end

  # @group Sizes
  # @label xs
  def size_xs
    render ::Decor::Suite::Tag.new(label: "Extra small", color: :primary, size: :xs)
  end

  # @group Sizes
  # @label sm
  def size_sm
    render ::Decor::Suite::Tag.new(label: "Small", color: :primary, size: :sm)
  end

  # @group Sizes
  # @label md
  def size_md
    render ::Decor::Suite::Tag.new(label: "Medium", color: :primary, size: :md)
  end

  # @group Sizes
  # @label lg
  def size_lg
    render ::Decor::Suite::Tag.new(label: "Large", color: :primary, size: :lg)
  end

  # @group Sizes
  # @label xl
  def size_xl
    render ::Decor::Suite::Tag.new(label: "Extra large", color: :primary, size: :xl)
  end

  # @group With Icon
  # @label Icon replaces LED
  def with_icon
    render ::Decor::Suite::Tag.new(label: "Featured", icon: "star", color: :warning)
  end
end
