# @label Icon
class ::Decor::IconPreview < ::Lookbook::Preview
  # @label Playground
  # @param name text
  # @param style select [outline, solid, small_solid]
  # @param sprite select [tabler, decor]
  # @param width number
  # @param height number
  def playground(name: "copy", style: :outline, sprite: :tabler, width: 24, height: 24)
    render ::Decor::Icon.new(
      name: name, style: style, sprite: sprite,
      width: width, height: height
    )
  end

  # @label Outline variant
  def outline_variant
    render ::Decor::Icon.new(name: "copy", style: :outline)
  end

  # @label Solid variant (auto-fallback when filled missing)
  def solid_variant
    render ::Decor::Icon.new(name: "copy", style: :solid)
  end

  # @label Decor sprite (purpose-drawn glyph)
  def decor_sprite
    render ::Decor::Icon.new(name: "check-tick", sprite: :decor, view_box: "0 0 12 10", width: 16, height: 16)
  end
end
