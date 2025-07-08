# @label Icon
class ::Decor::IconPreview < ::Lookbook::Preview
  # Icon
  # -------
  #
  # A Icon is an inline SVG icon that is read from a collection of SVG files in the assets directory.
  # Inherits from Svg component, so supports all sizing and accessibility features.
  #
  # You can also set the html class attribute using html_options[:class] or `element_classes` etc
  #
  # @label Playground
  # @param name select [chevron-right, gift, cube, download, play, home, user, star, heart, bell, check, x, plus, minus]
  # @param collection select [heroicons, icons]
  # @param variant select [outline, solid, small_solid]
  # @param inline toggle
  # @param size select [xs, sm, md, lg, xl]
  # @param width number
  # @param height number
  # @param title text
  # @param description text
  def playground(
    name: "cube",
    collection: :heroicons,
    variant: :outline,
    inline: false,
    size: :md,
    width: nil,
    height: nil,
    title: "Gift",
    description: "A gift icon"
  )
    render ::Decor::Icon.new(
      name: name,
      collection: collection,
      variant: variant,
      inline: inline,
      size: size,
      width: width,
      height: height,
      title: title,
      description: description
    )
  end

  # @group Collections
  # @label Heroicons Collection
  def collection_heroicons
    render ::Decor::Icon.new(
      name: "home",
      collection: :heroicons,
      variant: :outline,
      title: "Home Icon from Heroicons"
    )
  end

  # @group Collections
  # @label Icons Collection
  def collection_icons
    render ::Decor::Icon.new(
      name: "star",
      collection: :heroicons,
      variant: :outline,
      title: "Star Icon from Heroicons Collection"
    )
  end

  # @group Variants
  # @label Outline Variant
  def variant_outline
    render ::Decor::Icon.new(
      name: "heart",
      variant: :outline,
      title: "Outline Heart Icon"
    )
  end

  # @group Variants
  # @label Solid Variant
  def variant_solid
    render ::Decor::Icon.new(
      name: "heart",
      variant: :solid,
      title: "Solid Heart Icon"
    )
  end

  # @group Variants
  # @label Small Solid Variant
  def variant_small_solid
    render ::Decor::Icon.new(
      name: "star",
      variant: :small_solid,
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

  # @group Common Icons
  # @label Navigation Icons
  def common_navigation
    render_with_template(
      locals: {
        icons: [
          { name: "home", title: "Home" },
          { name: "user", title: "User" },
          { name: "chevron-right", title: "Next" },
          { name: "x", title: "Close" }
        ]
      }
    )
  end

  # @group Common Icons
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

  # @group Common Icons
  # @label Social Icons
  def common_social
    render_with_template(
      locals: {
        icons: [
          ::Decor::Icon.new(name: "heart", variant: :outline, title: "Like"),
          ::Decor::Icon.new(name: "star", variant: :outline, title: "Favorite"),
          ::Decor::Icon.new(name: "bell", title: "Notifications"),
          ::Decor::Icon.new(name: "gift", title: "Gift")
        ]
      }
    )
  end

  # @group Combinations
  # @label Large Solid with Accessibility
  def combo_large_solid_accessible
    render ::Decor::Icon.new(
      name: "star",
      variant: :solid,
      size: :lg,
      title: "Favorite Star",
      description: "A solid star icon indicating this item is favorited"
    )
  end

  # @group Combinations
  # @label Custom Dimensions Inline
  def combo_custom_inline
    render ::Decor::Icon.new(
      name: "play",
      variant: :solid,
      width: 80,
      height: 80,
      inline: true,
      title: "Play Button",
      description: "Large play button with inline SVG"
    )
  end

  # @group Combinations
  # @label Small Solid Collection Icons
  def combo_small_solid_icons
    render_with_template(
      locals: {
        icons: [
          ::Decor::Icon.new(
            name: "star",
            collection: :heroicons,
            variant: :small_solid,
            size: :sm,
            title: "Small Solid Star"
          ),
          ::Decor::Icon.new(
            name: "heart",
            collection: :heroicons,
            variant: :small_solid,
            size: :sm,
            title: "Small Solid Heart"
          )
        ]
      }
    )
  end
end
