# @label Carousel
class ::Decor::Suite::CarouselPreview < ::Lookbook::Preview
  # Carousel
  # --------
  #
  # Suite skin of the carousel. Renders Swiper-compatible markup with Suite
  # design tokens for theming (primary color, pagination bullets, focus ring,
  # arrow chrome). Supports image slides via `images:` or arbitrary content
  # slides via `with_slide`.
  #
  # @group Examples
  # @label Basic image carousel
  def basic_carousel
    render ::Decor::Suite::Carousel.new(
      images: [
        {url: "https://picsum.photos/seed/suite1/600/300", alt: "Slide 1"},
        {url: "https://picsum.photos/seed/suite2/600/300", alt: "Slide 2"},
        {url: "https://picsum.photos/seed/suite3/600/300", alt: "Slide 3"}
      ],
      max_height: 300
    )
  end

  # @group Examples
  # @label Multiple slides per view
  def multiple_slides
    render ::Decor::Suite::Carousel.new(
      images: [
        {url: "https://picsum.photos/seed/m1/300/200", alt: "Image 1"},
        {url: "https://picsum.photos/seed/m2/300/200", alt: "Image 2"},
        {url: "https://picsum.photos/seed/m3/300/200", alt: "Image 3"},
        {url: "https://picsum.photos/seed/m4/300/200", alt: "Image 4"},
        {url: "https://picsum.photos/seed/m5/300/200", alt: "Image 5"}
      ],
      slides_per_view: 3,
      max_height: 200
    )
  end

  # @group Examples
  # @label Responsive breakpoints
  def responsive_breakpoints
    render ::Decor::Suite::Carousel.new(
      images: [
        {url: "https://picsum.photos/seed/r1/400/250", alt: "R1"},
        {url: "https://picsum.photos/seed/r2/400/250", alt: "R2"},
        {url: "https://picsum.photos/seed/r3/400/250", alt: "R3"},
        {url: "https://picsum.photos/seed/r4/400/250", alt: "R4"},
        {url: "https://picsum.photos/seed/r5/400/250", alt: "R5"},
        {url: "https://picsum.photos/seed/r6/400/250", alt: "R6"}
      ],
      slides_per_view: {base: 1.25, sm: 2, md: 3, lg: 4},
      max_height: 250
    )
  end

  # @group Examples
  # @label Looping autoplay
  def autoplay
    render ::Decor::Suite::Carousel.new(
      images: [
        {url: "https://picsum.photos/seed/a1/600/300", alt: "A1"},
        {url: "https://picsum.photos/seed/a2/600/300", alt: "A2"},
        {url: "https://picsum.photos/seed/a3/600/300", alt: "A3"}
      ],
      loop: true,
      autoplay_delay: 3000,
      max_height: 300
    )
  end

  # @group Examples
  # @label Without arrows or pagination
  def minimal_chrome
    render ::Decor::Suite::Carousel.new(
      images: [
        {url: "https://picsum.photos/seed/x1/500/250", alt: "X1"},
        {url: "https://picsum.photos/seed/x2/500/250", alt: "X2"}
      ],
      show_arrows: false,
      show_pagination: false,
      max_height: 250
    )
  end

  # @group Playground
  # @param slides_per_view number
  # @param max_height number
  # @param space_between number
  # @param loop toggle
  # @param show_arrows toggle
  # @param show_pagination toggle
  # @param autoplay_delay number
  def playground(
    slides_per_view: 1,
    max_height: 300,
    space_between: 16,
    loop: false,
    show_arrows: true,
    show_pagination: true,
    autoplay_delay: 0
  )
    render ::Decor::Suite::Carousel.new(
      images: [
        {url: "https://picsum.photos/seed/p1/600/300", alt: "P1"},
        {url: "https://picsum.photos/seed/p2/600/300", alt: "P2"},
        {url: "https://picsum.photos/seed/p3/600/300", alt: "P3"},
        {url: "https://picsum.photos/seed/p4/600/300", alt: "P4"}
      ],
      slides_per_view: slides_per_view,
      max_height: max_height,
      space_between: space_between,
      loop: loop,
      show_arrows: show_arrows,
      show_pagination: show_pagination,
      autoplay_delay: autoplay_delay
    )
  end
end
