# @label Avatar
class ::Decor::AvatarPreview < ::ViewComponent::Preview
  # Avatars
  # -------
  #
  # An avatar is a small image that represents a user. It can display the
  # initials of the user's name or the user's profile picture. It can be
  # square or circular, and of many different sizes.
  #
  # @label Playground
  # @param initials text
  # @param image select [~, "https://i.pravatar.cc/300", "https://cataas.com/cat"]
  # @param shape select [circle, square]
  # @param size select [nano, micro, tiny, small, normal, medium, large, x_large, xx_large]
  # @param border toggle
  def playground(image: nil, initials: "JG", shape: :circle, size: :normal, border: true)
    render ::Decor::Avatar.new(initials: initials, url: image, shape: shape, size: size, border: border)
  end

  # @group Shapes
  # @label Circle Shape
  def shape_circle
    render ::Decor::Avatar.new(initials: "JD", shape: :circle)
  end

  # @group Shapes
  # @label Square Shape
  def shape_square
    render ::Decor::Avatar.new(initials: "JD", shape: :square)
  end

  # @group Shapes
  # @label Circle with Image
  def shape_circle_image
    render ::Decor::Avatar.new(url: "https://i.pravatar.cc/300", shape: :circle)
  end

  # @group Shapes
  # @label Square with Image
  def shape_square_image
    render ::Decor::Avatar.new(url: "https://i.pravatar.cc/300", shape: :square)
  end

  # @group Sizes
  # @label Nano Size
  def size_nano
    render ::Decor::Avatar.new(initials: "N", size: :nano)
  end

  # @group Sizes
  # @label Micro Size
  def size_micro
    render ::Decor::Avatar.new(initials: "M", size: :micro)
  end

  # @group Sizes
  # @label Tiny Size
  def size_tiny
    render ::Decor::Avatar.new(initials: "T", size: :tiny)
  end

  # @group Sizes
  # @label Small Size
  def size_small
    render ::Decor::Avatar.new(initials: "S", size: :small)
  end

  # @group Sizes
  # @label Normal Size
  def size_normal
    render ::Decor::Avatar.new(initials: "N", size: :normal)
  end

  # @group Sizes
  # @label Medium Size
  def size_medium
    render ::Decor::Avatar.new(initials: "M", size: :medium)
  end

  # @group Sizes
  # @label Large Size
  def size_large
    render ::Decor::Avatar.new(initials: "L", size: :large)
  end

  # @group Sizes
  # @label X-Large Size
  def size_x_large
    render ::Decor::Avatar.new(initials: "XL", size: :x_large)
  end

  # @group Sizes
  # @label XX-Large Size
  def size_xx_large
    render ::Decor::Avatar.new(initials: "XXL", size: :xx_large)
  end

  # @group With Images
  # @label Profile Picture
  def image_profile
    render ::Decor::Avatar.new(url: "https://i.pravatar.cc/300")
  end

  # @group With Images
  # @label Cat Picture
  def image_cat
    render ::Decor::Avatar.new(url: "https://cataas.com/cat")
  end

  # @group With Images
  # @label Large Profile Picture
  def image_large
    render ::Decor::Avatar.new(url: "https://i.pravatar.cc/300", size: :large)
  end

  # @group With Images
  # @label Medium Square Picture
  def image_medium_square
    render ::Decor::Avatar.new(url: "https://i.pravatar.cc/300", size: :medium, shape: :square)
  end

  # @group With Initials
  # @label Single Initial
  def initials_single
    render ::Decor::Avatar.new(initials: "J")
  end

  # @group With Initials
  # @label Two Initials
  def initials_double
    render ::Decor::Avatar.new(initials: "JD")
  end

  # @group With Initials
  # @label Three Initials
  def initials_triple
    render ::Decor::Avatar.new(initials: "JDK")
  end

  # @group With Initials
  # @label Long Name Initials
  def initials_long
    render ::Decor::Avatar.new(initials: "VLN")
  end

  # @group With Borders
  # @label Circle with Border
  def border_circle
    render ::Decor::Avatar.new(initials: "CB", border: true, shape: :circle)
  end

  # @group With Borders
  # @label Square with Border
  def border_square
    render ::Decor::Avatar.new(initials: "SB", border: true, shape: :square)
  end

  # @group With Borders
  # @label Large with Border
  def border_large
    render ::Decor::Avatar.new(initials: "LB", border: true, size: :large)
  end

  # @group With Borders
  # @label Image with Border
  def border_image
    render ::Decor::Avatar.new(url: "https://i.pravatar.cc/300", border: true)
  end

  # @group Combinations
  # @label Large Circle with Border
  def combo_large_circle_border
    render ::Decor::Avatar.new(
      initials: "LCB",
      size: :large,
      shape: :circle,
      border: true
    )
  end

  # @group Combinations
  # @label Medium Square Image
  def combo_medium_square_image
    render ::Decor::Avatar.new(
      url: "https://i.pravatar.cc/300",
      size: :medium,
      shape: :square
    )
  end

  # @group Combinations
  # @label X-Large Circle Image with Border
  def combo_xlarge_circle_image_border
    render ::Decor::Avatar.new(
      url: "https://i.pravatar.cc/300",
      size: :x_large,
      shape: :circle,
      border: true
    )
  end

  # @group Use Cases
  # @label User Profile
  def usecase_user_profile
    render ::Decor::Avatar.new(url: "https://i.pravatar.cc/300", size: :medium, border: true)
  end

  # @group Use Cases
  # @label Chat Message
  def usecase_chat_message
    render ::Decor::Avatar.new(initials: "JD", size: :small)
  end

  # @group Use Cases
  # @label Navigation Bar
  def usecase_navbar
    render ::Decor::Avatar.new(url: "https://i.pravatar.cc/300", size: :normal)
  end

  # @group Use Cases
  # @label Team Member Card
  def usecase_team_member
    render ::Decor::Avatar.new(url: "https://i.pravatar.cc/300", size: :large, border: true)
  end

  # @group Use Cases
  # @label Comment Author
  def usecase_comment_author
    render ::Decor::Avatar.new(initials: "CA", size: :tiny)
  end
end
