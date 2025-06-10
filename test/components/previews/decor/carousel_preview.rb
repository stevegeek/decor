# @label Carousel
class ::Decor::CarouselPreview < ::Lookbook::Preview
  # Carousel
  # -------
  #
  # A Carousel is a swipable container for a series of elements. These can be images, or anything
  # rendered to the slot `cards`
  #
  # @label Playground
  # @param slides_per_view number
  # @param max_height number
  def playground(slides_per_view: 1, max_height: 200)
    render ::Decor::Carousel.new(
      images: [
        {path: "pic.jpg", alt: "Image 1"},
        {url: "https://cataas.com/cat", alt: "Image 2"},
        {url: "https://i.pravatar.cc/300", alt: "Image 3"}
      ],
      slides_per_view: slides_per_view,
      max_height: max_height
    )
  end

  def with_slots
  end
end
