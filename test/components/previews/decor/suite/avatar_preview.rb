# @label Avatar
class ::Decor::Suite::AvatarPreview < ::Lookbook::Preview
  # Suite Avatar
  # ------------
  #
  # Suite-skinned avatar. Bespoke gradient placeholder palette
  # (:alt1..:alt5), hairline border, and custom rounded-card square shape.
  #
  # @label Playground
  # @param initials text
  # @param image select [~, "https://placehold.co/200x200"]
  # @param shape select [circle, square]
  # @param size select [xs, sm, md, lg, xl]
  # @param color select [primary, alt1, alt2, alt3, alt4, alt5, base, secondary, accent, neutral, success, error, warning, info]
  # @param status select [~, online, away, offline]
  # @param border toggle
  def playground(image: nil, initials: "JG", shape: :circle, size: :md, color: :primary, status: nil, border: false)
    render ::Decor::Suite::Avatar.new(
      initials: initials, url: image, shape: shape, size: size,
      color: color, status: status, border: border
    )
  end

  # @label All Sizes
  def all_sizes
    render_with_template
  end

  # @label All Colors
  def all_colors
    render_with_template
  end

  # @label Status Dots
  def status_dots
    render_with_template
  end
end
