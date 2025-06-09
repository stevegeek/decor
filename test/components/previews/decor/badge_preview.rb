# @label Badge
class ::Decor::BadgePreview < ::ViewComponent::Preview
  # Badge
  # -------
  #
  # A Badge is a little rectangular element which can be used to Label sections of the view. The Badge can have
  # an optional avatar in it.
  #
  # @label Playground
  # @param label text
  # @param icon select [~, check-circle, x, check, download, play]
  # @param variant select [outlined, filled]
  # @param style select [warning, success, error, info, standard]
  # @param size [Symbol] select [small, medium, large]
  # @param dashed toggle
  # @param image select [~, "https://i.pravatar.cc/300", "https://cataas.com/cat"]
  # @param initials text

  def playground(label: "My Badge", size: nil, icon: nil, style: :info, variant: :outlined, image: nil, initials: nil, dashed: false)
    render ::Decor::Badge.new(label:, icon:, size:, style:, variant:, url: image, initials:, dashed:)
  end
end
