# @label Avatar
class ::Decor::Daisy::AvatarPreview < ::Lookbook::Preview
  # Avatars
  # -------
  #
  # An avatar is a small image that represents a user. It can display the
  # initials of the user's name or the user's profile picture. It can be
  # square or circular, and of many different sizes.
  #
  # @group Examples
  # @label Initials
  def only_initials
    render ::Decor::Daisy::Avatar.new(initials: "JD", size: :sm)
  end

  # @group Examples
  # @label Initials - Colored
  def only_initials_colored
    render ::Decor::Daisy::Avatar.new(initials: "JD", size: :sm, color: :error)
  end

  # @group Examples
  # @label Circular
  def circular
    render ::Decor::Daisy::Avatar.new(url: "https://i.pravatar.cc/300", size: :md)
  end

  # @group Examples
  # @label Circular - Outlined
  def circular_outlined
    render ::Decor::Daisy::Avatar.new(initials: "AB", size: :md, style: :outlined)
  end

  # @group Examples
  # @label Large Circle with ring
  def combo_large_circle_ring
    render ::Decor::Daisy::Avatar.new(
      initials: "LCB",
      size: :lg,
      shape: :circle,
      border: true
    )
  end

  # @group Examples
  # @label Large Square Image
  def combo_large_square_image
    render ::Decor::Daisy::Avatar.new(
      url: "https://i.pravatar.cc/300",
      size: :lg,
      shape: :square
    )
  end

  # @group Examples
  # @label X-Large Circle Image with ring
  def combo_xlarge_circle_image_ring
    render ::Decor::Daisy::Avatar.new(
      url: "https://i.pravatar.cc/300",
      size: :xl,
      shape: :circle,
      border: true
    )
  end

  # @group Examples
  # @label Colorful Team
  def colorful_team_example
    render_with_template(
      locals: {
        avatars: [
          ::Decor::Daisy::Avatar.new(initials: "JD", color: :primary, style: :filled),
          ::Decor::Daisy::Avatar.new(initials: "SM", color: :secondary, style: :outlined),
          ::Decor::Daisy::Avatar.new(initials: "AK", color: :accent, style: :ghost),
          ::Decor::Daisy::Avatar.new(initials: "TL", color: :success, style: :filled)
        ]
      }
    )
  end

  # @group Examples
  # @label Color Effects on Image Avatars
  def image_color_effects_example
    render_with_template(
      locals: {
        avatars: [
          ::Decor::Daisy::Avatar.new(url: "https://i.pravatar.cc/300", color: :primary),
          ::Decor::Daisy::Avatar.new(url: "https://i.pravatar.cc/300", color: :primary, border: true),
          ::Decor::Daisy::Avatar.new(url: "https://i.pravatar.cc/300", color: :secondary),
          ::Decor::Daisy::Avatar.new(url: "https://i.pravatar.cc/300", color: :secondary, border: true),
          ::Decor::Daisy::Avatar.new(url: "https://i.pravatar.cc/300", color: :error),
          ::Decor::Daisy::Avatar.new(url: "https://i.pravatar.cc/300", color: :error, style: :outlined),
          ::Decor::Daisy::Avatar.new(url: "https://i.pravatar.cc/300", color: :error, style: :outlined, border: true),
          ::Decor::Daisy::Avatar.new(url: "https://decor/404", color: :error, style: :filled)
        ]
      }
    )
  end

  # @group Playground
  # @param initials text
  # @param image select [~, "https://i.pravatar.cc/300", "https://cataas.com/cat"]
  # @param shape [Symbol] select [~, circle, square]
  # @param border toggle
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  def playground(image: nil, initials: "JG", shape: nil, size: nil, border: true, color: nil, style: nil)
    render ::Decor::Daisy::Avatar.new(initials: initials, url: image, shape: shape, size: size, border: border, color: color, style: style)
  end

  # @group Image avatars
  # @label Profile Picture
  def image_profile
    render ::Decor::Daisy::Avatar.new(url: "https://i.pravatar.cc/300")
  end

  # @group Image avatars
  # @label Cat Picture
  def image_cat
    render ::Decor::Daisy::Avatar.new(url: "https://cataas.com/cat")
  end

  # @group Image avatars
  # @label Large Profile Picture
  def image_large
    render ::Decor::Daisy::Avatar.new(url: "https://i.pravatar.cc/300", size: :lg)
  end

  # @group Image avatars
  # @label Large Square Picture
  def image_large_square
    render ::Decor::Daisy::Avatar.new(url: "https://i.pravatar.cc/300", size: :lg, shape: :square)
  end

  # @group Placeholder avatars
  # @label Single Initial
  def initials_single
    render ::Decor::Daisy::Avatar.new(initials: "J")
  end

  # @group Placeholder avatars
  # @label Two Initials
  def initials_double
    render ::Decor::Daisy::Avatar.new(initials: "JD")
  end

  # @group Placeholder avatars
  # @label Three Initials
  def initials_triple
    render ::Decor::Daisy::Avatar.new(initials: "JDK")
  end

  # @group Placeholder avatars
  # @label Long Name Initials
  def initials_long
    render ::Decor::Daisy::Avatar.new(initials: "VLN")
  end

  # @group Shapes
  # @label Circle Shape
  def shape_circle
    render ::Decor::Daisy::Avatar.new(initials: "JD", shape: :circle)
  end

  # @group Shapes
  # @label Square Shape
  def shape_square
    render ::Decor::Daisy::Avatar.new(initials: "JD", shape: :square)
  end

  # @group Shapes
  # @label Circle with Image
  def shape_circle_image
    render ::Decor::Daisy::Avatar.new(url: "https://i.pravatar.cc/300", shape: :circle)
  end

  # @group Shapes
  # @label Square with Image
  def shape_square_image
    render ::Decor::Daisy::Avatar.new(url: "https://i.pravatar.cc/300", shape: :square)
  end

  # @group Sizes
  # @label XS Size
  def size_xs
    render ::Decor::Daisy::Avatar.new(initials: "XS", size: :xs)
  end

  # @group Sizes
  # @label SM Size
  def size_sm
    render ::Decor::Daisy::Avatar.new(initials: "SM", size: :sm)
  end

  # @group Sizes
  # @label MD Size (Default)
  def size_md
    render ::Decor::Daisy::Avatar.new(initials: "MD", size: :md)
  end

  # @group Sizes
  # @label LG Size
  def size_lg
    render ::Decor::Daisy::Avatar.new(initials: "LG", size: :lg)
  end

  # @group Sizes
  # @label XL Size
  def size_xl
    render ::Decor::Daisy::Avatar.new(initials: "XL", size: :xl)
  end

  # @group Colors
  # @label Primary Color
  def color_primary
    render ::Decor::Daisy::Avatar.new(initials: "PC", color: :primary)
  end

  # @group Colors
  # @label Secondary Color
  def color_secondary
    render ::Decor::Daisy::Avatar.new(initials: "SC", color: :secondary)
  end

  # @group Colors
  # @label Accent Color
  def color_accent
    render ::Decor::Daisy::Avatar.new(initials: "AC", color: :accent)
  end

  # @group Colors
  # @label Success Color
  def color_success
    render ::Decor::Daisy::Avatar.new(initials: "SU", color: :success)
  end

  # @group Colors
  # @label Error Color
  def color_error
    render ::Decor::Daisy::Avatar.new(initials: "ER", color: :error)
  end

  # @group Colors
  # @label Warning Color
  def color_warning
    render ::Decor::Daisy::Avatar.new(initials: "WA", color: :warning)
  end

  # @group Colors
  # @label Info Color
  def color_info
    render ::Decor::Daisy::Avatar.new(initials: "IN", color: :info)
  end

  # @group Styles
  # @label Filled Style
  def variant_filled
    render ::Decor::Daisy::Avatar.new(initials: "FV", style: :filled, color: :primary)
  end

  # @group Styles
  # @label Outlined Style
  def variant_outlined
    render ::Decor::Daisy::Avatar.new(initials: "OV", style: :outlined, color: :primary)
  end

  # @group Styles
  # @label Ghost Style
  def variant_ghost
    render ::Decor::Daisy::Avatar.new(initials: "GV", style: :ghost, color: :primary)
  end

  # @group Styles
  # @label Filled Style
  def variant_filled_with_image
    render ::Decor::Daisy::Avatar.new(url: "https://i.pravatar.cc/300", style: :filled, color: :primary)
  end

  # @group Styles
  # @label Outlined Style
  def variant_outlined_with_image
    render ::Decor::Daisy::Avatar.new(url: "https://i.pravatar.cc/300", style: :outlined, color: :primary)
  end

  # @group Styles
  # @label Ghost Style
  def variant_ghost_with_image
    render ::Decor::Daisy::Avatar.new(url: "https://i.pravatar.cc/300", style: :ghost, color: :primary)
  end

  # @group With a ring
  # @label Circle with ring
  def ring_circle
    render ::Decor::Daisy::Avatar.new(initials: "CB", border: true, shape: :circle)
  end

  # @group With a ring
  # @label Square with ring
  def ring_square
    render ::Decor::Daisy::Avatar.new(initials: "SB", border: true, shape: :square)
  end

  # @group With a ring
  # @label Large with ring
  def ring_large
    render ::Decor::Daisy::Avatar.new(initials: "LB", border: true, size: :lg)
  end

  # @group With a ring
  # @label Image with ring
  def ring_image
    render ::Decor::Daisy::Avatar.new(url: "https://i.pravatar.cc/300", border: true)
  end

  # @group With a ring
  # @label Initials, Outlined, with ring
  def ring_outlined_initials
    render ::Decor::Daisy::Avatar.new(initials: "OB", border: true, style: :outlined, size: :md)
  end
end
