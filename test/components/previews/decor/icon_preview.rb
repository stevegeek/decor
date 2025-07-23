# @label Icon
class ::Decor::IconPreview < ::Lookbook::Preview
  # Icon
  # -------
  #
  # An Icon is an inline SVG icon that is read from a collection of SVG files in the assets directory.
  # Inherits from Svg component, so supports all sizing and accessibility features.
  #
  # Set the color using `classes` prop. The icon can be inlined in the HTML or loaded externally.
  #
  # @group Examples
  # @label Action Icons
  def common_actions
    render_with_template(
      locals: {
        icons: [
          ::Decor::Icon.new(name: "plus", title: "Add"),
          ::Decor::Icon.new(name: "minus", title: "Remove"),
          ::Decor::Icon.new(name: "check", title: "Confirm"),
          ::Decor::Icon.new(name: "download", title: "Download")
        ]
      }
    )
  end

  # @group Examples
  # @label Other Icons
  def common_fun
    render_with_template(
      locals: {
        icons: [
          ::Decor::Icon.new(name: "heart", style: :outline, title: "Like"),
          ::Decor::Icon.new(name: "star", style: :outline, title: "Favorite"),
          ::Decor::Icon.new(name: "bell", title: "Notifications"),
          ::Decor::Icon.new(name: "gift", title: "Gift")
        ]
      }
    )
  end

  # @group Examples
  # @label Large Solid with Accessibility
  def combo_large_solid_accessible
    render ::Decor::Icon.new(
      name: "star",
      style: :solid,
      size: :lg,
      title: "Favorite Star",
      description: "A solid star icon indicating this item is favorited"
    )
  end

  # @group Examples
  # @label Custom Dimensions Inline
  def combo_custom_inline
    render ::Decor::Icon.new(
      name: "play",
      style: :solid,
      width: 80,
      height: 80,
      inline: true,
      title: "Play Button",
      description: "Large play button with inline SVG"
    )
  end

  # @group Examples
  # @label Small Solid Collection Icons
  def combo_small_solid_icons
    render_with_template(
      locals: {
        icons: [
          ::Decor::Icon.new(
            name: "star",
            collection: :heroicons,
            style: :small_solid,
            size: :sm,
            title: "Small Solid Star"
          ),
          ::Decor::Icon.new(
            name: "heart",
            collection: :heroicons,
            style: :small_solid,
            size: :sm,
            title: "Small Solid Heart"
          )
        ]
      }
    )
  end

  # @group Playground
  # @param name select [chevron-right, gift, cube, download, play, home, user, star, heart, bell, check, x, plus, minus]
  # @param collection select [heroicons, icons]
  # @param inline toggle
  # @param width number
  # @param height number
  # @param title text
  # @param description text
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, outline, solid, small_solid]
  def playground(
    name: "cube",
    collection: :heroicons,
    inline: false,
    width: nil,
    height: nil,
    title: "Gift",
    description: "A gift icon",
    size: nil,
    color: nil,
    style: nil
  )
    render ::Decor::Icon.new(
      name: name,
      collection: collection,
      inline: inline,
      width: width,
      height: height,
      title: title,
      description: description,
      size: size,
      color: color,
      style: style
    )
  end

  # @group Collections
  # @label Heroicons Collection
  def collection_heroicons
    render ::Decor::Icon.new(
      name: "home",
      collection: :heroicons,
      style: :outline,
      title: "Home Icon from Heroicons"
    )
  end

  # @group Collections
  # @label Icons Collection
  def collection_icons
    render ::Decor::Icon.new(
      name: "star",
      collection: :heroicons,
      style: :outline,
      title: "Star Icon from Heroicons Collection"
    )
  end

  # @group Styles
  # @label Outline Style
  def style_outline
    render ::Decor::Icon.new(
      name: "heart",
      style: :outline,
      title: "Outline Heart Icon"
    )
  end

  # @group Styles
  # @label Solid Style
  def style_solid
    render ::Decor::Icon.new(
      name: "heart",
      style: :solid,
      title: "Solid Heart Icon"
    )
  end

  # @group Styles
  # @label Small Solid Style
  def style_small_solid
    render ::Decor::Icon.new(
      name: "star",
      style: :small_solid,
      title: "Small Solid Star Icon"
    )
  end

  # @group Sizes
  # @label Extra Small (xs)
  def size_xs
    render ::Decor::Icon.new(
      name: "bell",
      size: :xs,
      title: "Extra Small Bell"
    )
  end

  # @group Sizes
  # @label Small (sm)
  def size_sm
    render ::Decor::Icon.new(
      name: "bell",
      size: :sm,
      title: "Small Bell"
    )
  end

  # @group Sizes
  # @label Medium (md)
  def size_md
    render ::Decor::Icon.new(
      name: "bell",
      size: :md,
      title: "Medium Bell"
    )
  end

  # @group Sizes
  # @label Large (lg)
  def size_lg
    render ::Decor::Icon.new(
      name: "bell",
      size: :lg,
      title: "Large Bell"
    )
  end

  # @group Sizes
  # @label Extra Large (xl)
  def size_xl
    render ::Decor::Icon.new(
      name: "bell",
      size: :xl,
      title: "Extra Large Bell"
    )
  end

  # @group Custom Dimensions
  # @label Custom Width and Height
  def custom_dimensions
    render ::Decor::Icon.new(
      name: "user",
      width: 48,
      height: 48,
      title: "Custom 48x48 User Icon"
    )
  end

  # @group Custom Dimensions
  # @label Custom Width Only
  def custom_width
    render ::Decor::Icon.new(
      name: "download",
      width: 64,
      title: "Custom Width Download Icon"
    )
  end

  # @group Loading Types
  # @label Inline Icon
  def inline_true
    render ::Decor::Icon.new(
      name: "check",
      inline: true,
      title: "Inline Check Icon",
      description: "Icon content is inlined in the HTML"
    )
  end

  # @group Loading Types
  # @label External Icon
  def inline_false
    render ::Decor::Icon.new(
      name: "check",
      inline: false,
      title: "External Check Icon",
      description: "Icon is loaded externally via data-src"
    )
  end

  # @group Edge Cases
  # @label Nil Style (Should Use Default)
  def nil_style
    render ::Decor::Icon.new(
      name: "cube",
      style: nil,
      title: "Icon with nil style",
      description: "Should fall back to default :outline style"
    )
  end
end
