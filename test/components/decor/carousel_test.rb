require "test_helper"

class Decor::CarouselTest < ActiveSupport::TestCase
  test "renders successfully with default attributes" do
    component = Decor::Carousel.new
    rendered = render_component(component)

    assert_includes rendered, "carousel"
    assert_includes rendered, "decor--carousel"
  end

  test "renders with daisyUI carousel classes" do
    component = Decor::Carousel.new
    rendered = render_component(component)

    assert_includes rendered, "carousel"
    assert_includes rendered, "carousel-center"
  end

  test "supports items slot" do
    component = Decor::Carousel.new
    rendered = render_component(component) do |c|
      c.with_items { "<div class='carousel-item'>Item 1</div>" }
    end

    assert_includes rendered, "carousel-item"
    assert_includes rendered, "Item 1"
  end

  test "renders with scrollable container" do
    component = Decor::Carousel.new
    rendered = render_component(component)

    assert_includes rendered, "overflow-x-auto"
  end

  test "supports multiple carousel items" do
    component = Decor::Carousel.new
    rendered = render_component(component) do |c|
      c.with_items do
        "<div class='carousel-item'>Item 1</div><div class='carousel-item'>Item 2</div><div class='carousel-item'>Item 3</div>"
      end
    end

    assert_includes rendered, "Item 1"
    assert_includes rendered, "Item 2"
    assert_includes rendered, "Item 3"
  end

  test "renders with correct HTML structure" do
    component = Decor::Carousel.new
    fragment = render_fragment(component)

    carousel_div = fragment.at_css(".carousel")
    assert_not_nil carousel_div
    assert_includes carousel_div["class"], "decor--carousel"
    assert_includes carousel_div["class"], "carousel-center"
  end

  test "component inherits from PhlexComponent" do
    component = Decor::Carousel.new

    assert component.is_a?(Decor::PhlexComponent)
  end

  test "applies default element classes" do
    component = Decor::Carousel.new
    rendered = render_component(component)

    assert_includes rendered, "carousel carousel-center"
    assert_includes rendered, "overflow-x-auto"
  end

  test "renders without items when none provided" do
    component = Decor::Carousel.new
    rendered = render_component(component)

    # Should still render the container
    assert_includes rendered, "carousel"
    assert_includes rendered, "decor--carousel"
  end

  test "supports complex carousel item content" do
    component = Decor::Carousel.new
    rendered = render_component(component) do |c|
      c.with_items do
        "<div class='carousel-item'><img src='image1.jpg' alt='Image 1' /></div><div class='carousel-item'><img src='image2.jpg' alt='Image 2' /></div>"
      end
    end

    assert_includes rendered, "image1.jpg"
    assert_includes rendered, "image2.jpg"
    assert_includes rendered, "Image 1"
    assert_includes rendered, "Image 2"
  end

  test "renders as div element" do
    component = Decor::Carousel.new
    fragment = render_fragment(component)

    div = fragment.at_css("div")
    assert_not_nil div
    assert_includes div["class"], "carousel"
  end

  test "supports custom CSS classes" do
    component = Decor::Carousel.new(class: "custom-carousel")
    rendered = render_component(component)

    assert_includes rendered, "custom-carousel"
    assert_includes rendered, "carousel"
  end

  test "renders with responsive design classes" do
    component = Decor::Carousel.new
    rendered = render_component(component)

    assert_includes rendered, "carousel-center"
    assert_includes rendered, "overflow-x-auto"
  end

  test "supports carousel items with different content types" do
    component = Decor::Carousel.new
    rendered = render_component(component) do |c|
      c.with_items do
        "<div class='carousel-item'><div class='card'>Card 1</div></div><div class='carousel-item'><p>Text item</p></div>"
      end
    end

    assert_includes rendered, "Card 1"
    assert_includes rendered, "Text item"
    assert_includes rendered, "carousel-item"
  end
end
