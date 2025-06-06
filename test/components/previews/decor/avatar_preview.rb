# @label Avatar
class ::Decor::AvatarPreview < ::ViewComponent::Preview
  # Avatars
  # -------
  #
  # An avatar is a small image that represents a user. It can display the
  # initials of the user's name or the user's profile picture. It can be
  # square or circular, and of many different sizes.
  #
  # Note that the `shape` and `size` attributes are symbols.
  #
  # @label Playground
  # @param initials text
  # @param image select [~, "https://i.pravatar.cc/300", "https://cataas.com/cat"]
  # @param shape select [circle, square]
  # @param size select [tiny, small, normal, medium, large, x_large, xx_large]
  # @param border toggle
  def playground(image: nil, initials: "JG", shape: :circle, size: :normal, border: true)
    render ::Decor::Avatar.new(initials: initials, url: image, shape: shape, size: size, border: border)
  end
end
