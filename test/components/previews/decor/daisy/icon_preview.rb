# @label Icon
class ::Decor::Daisy::IconPreview < ::Lookbook::Preview
  # Icon
  # -------
  #
  # A sprite-based SVG icon component backed by the Tabler icon set (~5000 outline icons).
  # Use `Decor::Icon` directly; both Daisy and Suite skins share this same class.
  #
  # Set the color using Tailwind classes via `html_options: {class: "..."}`.
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
  # @label Large Solid
  def combo_large_solid_accessible
    render ::Decor::Icon.new(
      name: "star",
      style: :solid,
      width: 40,
      height: 40,
      title: "Favorite Star"
    )
  end

  # @group Examples
  # @label Custom Dimensions
  def combo_custom_inline
    render ::Decor::Icon.new(
      name: "player-play",
      style: :solid,
      width: 80,
      height: 80,
      title: "Play Button"
    )
  end

  # @group Examples
  # @label Small Solid Icons
  def combo_small_solid_icons
    render_with_template(
      locals: {
        icons: [
          ::Decor::Icon.new(
            name: "star",
            style: :small_solid,
            width: 16,
            height: 16,
            title: "Small Solid Star"
          ),
          ::Decor::Icon.new(
            name: "heart",
            style: :small_solid,
            width: 16,
            height: 16,
            title: "Small Solid Heart"
          )
        ]
      }
    )
  end

  # @group Playground
  # @param name select [chevron-right, gift, cube, download, player-play, home, user, star, heart, bell, check, x, plus, minus]
  # @param width number
  # @param height number
  # @param title text
  # @param style [Symbol] select [~, outline, solid, small_solid]
  def playground(
    name: "cube",
    width: nil,
    height: nil,
    title: "Icon",
    style: nil
  )
    render ::Decor::Icon.new(
      name: name,
      width: width,
      height: height,
      title: title,
      style: style
    )
  end

  # @group Sprites
  # @label Tabler Sprite (default)
  def sprite_tabler
    render ::Decor::Icon.new(
      name: "home",
      style: :outline,
      title: "Home Icon from Tabler"
    )
  end

  # @group Sprites
  # @label Decor Custom Sprite
  def sprite_decor
    render ::Decor::Icon.new(
      name: "check-tick",
      sprite: :decor,
      view_box: "0 0 12 10",
      width: 16,
      height: 16,
      title: "Check Tick from Decor sprite"
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

  # @group Custom Dimensions
  # @label Width and Height via pixels
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

  # @group Edge Cases
  # @label Nil Style (Should Use Default)
  def nil_style
    render ::Decor::Icon.new(
      name: "cube",
      style: nil,
      title: "Icon with nil style"
    )
  end
end
