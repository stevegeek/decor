# @label Svg
class ::Decor::SvgPreview < ::Lookbook::Preview
  # Svg
  # -------
  #
  # An inline svg from a file path.
  # Supports different sizes, inline/external loading, and accessibility attributes.
  #
  # You can also set the html class attribute using html_options[:class] or `element_classes` etc
  #
  # @group Examples
  # @label Large External with Accessibility
  def combo_large_external_accessible
    render ::Decor::Svg.new(
      file_name: "svgs/d-geometric.svg",
      size: :lg,
      inline: false,
      title: "Geometric Design",
      description: "A geometric logo with angular shapes"
    )
  end

  # @group Examples
  # @label Custom Dimensions with Title
  def combo_custom_with_title
    render ::Decor::Svg.new(
      file_name: "svgs/d-rounded.svg",
      width: 80,
      height: 80,
      title: "Rounded Logo",
      description: "A logo with rounded corners and soft edges"
    )
  end

  # @group Playground
  # @param file_name select [svgs/d-modern.svg, svgs/d-rounded.svg, svgs/d-geometric.svg]
  # @param inline toggle
  # @param size select [xs, sm, md, lg, xl]
  # @param width number
  # @param height number
  # @param title text
  # @param description text
  def playground(
    file_name: "svgs/d-modern.svg",
    inline: true,
    size: :md,
    width: nil,
    height: nil,
    title: "Dee",
    description: "A letter, D"
  )
    render ::Decor::Svg.new(
      file_name: file_name,
      inline: inline,
      size: size,
      width: width,
      height: height,
      title: title,
      description: description
    )
  end

  # @group Sizes
  # @label Extra Small (xs)
  def size_xs
    render ::Decor::Svg.new(
      file_name: "svgs/d-modern.svg",
      size: :xs,
      title: "Extra Small Icon"
    )
  end

  # @group Sizes
  # @label Small (sm)
  def size_sm
    render ::Decor::Svg.new(
      file_name: "svgs/d-modern.svg",
      size: :sm,
      title: "Small Icon"
    )
  end

  # @group Sizes
  # @label Medium (md)
  def size_md
    render ::Decor::Svg.new(
      file_name: "svgs/d-modern.svg",
      size: :md,
      title: "Medium Icon"
    )
  end

  # @group Sizes
  # @label Large (lg)
  def size_lg
    render ::Decor::Svg.new(
      file_name: "svgs/d-modern.svg",
      size: :lg,
      title: "Large Icon"
    )
  end

  # @group Sizes
  # @label Extra Large (xl)
  def size_xl
    render ::Decor::Svg.new(
      file_name: "svgs/d-modern.svg",
      size: :xl,
      title: "Extra Large Icon"
    )
  end

  # @group Custom Dimensions
  # @label Custom Width and Height
  def custom_dimensions
    render ::Decor::Svg.new(
      file_name: "svgs/d-modern.svg",
      width: 48,
      height: 48,
      title: "Custom 48x48 Icon"
    )
  end

  # @group Custom Dimensions
  # @label Custom Width Only
  def custom_width
    render ::Decor::Svg.new(
      file_name: "svgs/d-modern.svg",
      width: 64,
      title: "Custom Width Icon"
    )
  end

  # @group Custom Dimensions
  # @label Custom Height Only
  def custom_height
    render ::Decor::Svg.new(
      file_name: "svgs/d-modern.svg",
      height: 64,
      title: "Custom Height Icon"
    )
  end

  # @group Loading Types
  # @label Inline SVG
  def inline_true
    render ::Decor::Svg.new(
      file_name: "svgs/d-modern.svg",
      inline: true,
      title: "Inline SVG",
      description: "SVG content is inlined in the HTML"
    )
  end

  # @group Loading Types
  # @label External SVG
  def inline_false
    render ::Decor::Svg.new(
      file_name: "svgs/d-modern.svg",
      inline: false,
      title: "External SVG",
      description: "SVG is loaded externally via data-src"
    )
  end

  # @group Accessibility
  # @label With Title and Description
  def accessibility_full
    render ::Decor::Svg.new(
      file_name: "svgs/d-modern.svg",
      title: "Modern Logo",
      description: "A modern geometric logo design with clean lines"
    )
  end
end
