# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::CarouselTest < ActiveSupport::TestCase
  test "renders root as a section with carousel role + aria attributes" do
    html = render_component(::Decor::Suite::Carousel.new)
    assert_includes html, "<section"
    assert_includes html, "role=\"region\""
    assert_includes html, "aria-roledescription=\"carousel\""
    assert_includes html, "aria-label=\"Image carousel\""
  end

  test "custom aria_label overrides default" do
    html = render_component(::Decor::Suite::Carousel.new(aria_label: "Product gallery"))
    assert_includes html, "aria-label=\"Product gallery\""
  end

  test "root starts hidden to suppress pre-init stacked-slides flash" do
    html = render_component(::Decor::Suite::Carousel.new)
    assert_includes html, "decor:hidden"
  end

  test "root carries swiper theme CSS variables wired to suite-primary token" do
    html = render_component(::Decor::Suite::Carousel.new)
    assert_includes html, "--swiper-theme-color:var(--color-suite-primary-500)"
    assert_includes html, "--swiper-pagination-color:var(--color-suite-primary-500)"
  end

  test "renders swiper-wrapper container" do
    html = render_component(::Decor::Suite::Carousel.new)
    assert_includes html, "swiper-wrapper"
  end

  test "renders image slides with url verbatim" do
    html = render_component(::Decor::Suite::Carousel.new(
      images: [
        {url: "https://example.com/a.jpg", alt: "A"},
        {url: "/local/b.png", alt: "B"}
      ]
    ))
    assert_includes html, "swiper-slide"
    assert_includes html, "src=\"https://example.com/a.jpg\""
    assert_includes html, "alt=\"A\""
    assert_includes html, "src=\"/local/b.png\""
    assert_includes html, "alt=\"B\""
  end

  test "images with path are resolved via Rails image_path helper" do
    html = render_component(::Decor::Suite::Carousel.new(
      images: [{path: "logo.png", alt: "X"}]
    ))
    # Asset pipeline fingerprints logo.png; the resolved src starts with /assets/logo
    assert_includes html, "/assets/logo"
    assert_includes html, "alt=\"X\""
  end

  test "applies max_height inline style and centered image classes when set" do
    html = render_component(::Decor::Suite::Carousel.new(
      images: [{url: "https://example.com/a.jpg", alt: "A"}],
      max_height: 280
    ))
    assert_includes html, "max-height: 280px"
    assert_includes html, "decor:w-auto"
    assert_includes html, "decor:mx-auto"
  end

  test "without max_height image gets full-width class" do
    html = render_component(::Decor::Suite::Carousel.new(
      images: [{url: "https://example.com/a.jpg", alt: "A"}]
    ))
    assert_includes html, "decor:w-full"
    refute_includes html, "max-height:"
  end

  test "renders prev + next navigation buttons by default" do
    html = render_component(::Decor::Suite::Carousel.new)
    assert_includes html, "swiper-button-prev"
    assert_includes html, "swiper-button-next"
    assert_includes html, "aria-label=\"Previous slide\""
    assert_includes html, "aria-label=\"Next slide\""
  end

  test "navigation buttons use suite tokens for chrome" do
    html = render_component(::Decor::Suite::Carousel.new)
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:hover:bg-suite-gray-25"
    assert_includes html, "decor:duration-suite-fast"
  end

  test "show_arrows: false suppresses navigation buttons" do
    html = render_component(::Decor::Suite::Carousel.new(show_arrows: false))
    refute_includes html, "swiper-button-prev"
    refute_includes html, "swiper-button-next"
  end

  test "renders pagination element by default" do
    html = render_component(::Decor::Suite::Carousel.new)
    # Match the pagination DIV (not the --swiper-pagination-color CSS variable on the root).
    assert_includes html, "class=\"swiper-pagination"
  end

  test "show_pagination: false suppresses pagination element" do
    html = render_component(::Decor::Suite::Carousel.new(show_pagination: false))
    refute_includes html, "class=\"swiper-pagination"
  end

  test "stimulus controller path is decor--suite--carousel" do
    html = render_component(::Decor::Suite::Carousel.new)
    assert_includes html, "decor--suite--carousel"
  end

  test "stimulus values pass through space_between, loop, autoplay_delay" do
    html = render_component(::Decor::Suite::Carousel.new(
      space_between: 24,
      loop: true,
      autoplay_delay: 5000
    ))
    assert_includes html, "space-between-value=\"24\""
    assert_includes html, "loop-value=\"true\""
    assert_includes html, "autoplay-delay-value=\"5000\""
  end

  test "integer slides_per_view is normalised to {base: N} for stimulus value" do
    html = render_component(::Decor::Suite::Carousel.new(slides_per_view: 3))
    assert_includes html, "slides-per-view-value"
    assert_includes html, "&quot;base&quot;:3"
  end

  test "hash slides_per_view passes through unchanged for stimulus value" do
    html = render_component(::Decor::Suite::Carousel.new(
      slides_per_view: {base: 1.25, md: 3}
    ))
    assert_includes html, "&quot;base&quot;:1.25"
    assert_includes html, "&quot;md&quot;:3"
  end

  test "nil slides_per_view emits empty object for stimulus value" do
    html = render_component(::Decor::Suite::Carousel.new)
    assert_includes html, "slides-per-view-value=\"{}\""
  end

  test "renders content slides registered via with_slide" do
    component = ::Decor::Suite::Carousel.new
    component.with_slide { "<p>custom-slide-content</p>".html_safe }
    html = render_component(component)
    assert_includes html, "custom-slide-content"
    assert_includes html, "swiper-slide"
  end
end
