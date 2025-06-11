# @label Svg
class ::Decor::SvgPreview < ::Lookbook::Preview
  # Svg
  # -------
  #
  # An inline svg from assets/svgs/
  #
  # You can also set the html class attribute using html_options[:class] or `element_classes` etc
  #
  # @label Playground
  # @param name select [d-modern, d-rounded, d-geometric]
  # @param inline toggle
  # @param title text
  # @param description text
  def playground(name: "d-modern", inline: true, title: "Dee", description: "A letter, D")
    render ::Decor::Svg.new(
      name: name,
      inline: inline,
      title: title,
      description: description,
      root_path: "svgs"
    )
  end
end
