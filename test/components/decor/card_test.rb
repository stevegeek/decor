# frozen_string_literal: true

require "test_helper"

class Decor::CardTest < ActiveSupport::TestCase
  def test_renders_basic_card
    component = Decor::Card.new

    rendered = render_fragment(component) { "Card content" }

    # Should have daisyUI card classes
    assert rendered.css(".card.bg-base-100.shadow-sm").any?

    # Should render content in card-body
    assert rendered.css(".card-body").any?
    assert_includes rendered.text, "Card content"
  end

  def test_renders_card_with_header_slot
    component = Decor::Card.new
    component.with_header { "Card Header" }

    rendered = render_fragment(component) { "Card body content" }

    # Should render header slot content
    assert_includes rendered.text, "Card Header"

    # Should also render body content
    assert_includes rendered.text, "Card body content"

    # Should have card-body wrapper
    assert rendered.css(".card-body").any?
  end

  def test_card_without_header_slot
    component = Decor::Card.new

    rendered = render_fragment(component) { "Just body content" }

    # Should only render body content
    assert_includes rendered.text, "Just body content"

    # Should have card-body wrapper
    assert rendered.css(".card-body").any?
  end

  def test_renders_card_with_title
    component = Decor::Card.new(title: "My Card Title")

    rendered = render_fragment(component) { "Card body content" }

    # Should render title in card-title span inside card-body
    title_element = rendered.css(".card-body span.card-title").first
    assert title_element
    assert_equal "My Card Title", title_element.text

    # Should also render body content
    assert_includes rendered.text, "Card body content"

    # Should have card-body wrapper
    assert rendered.css(".card-body").any?
  end

  def test_card_with_both_header_slot_and_title
    component = Decor::Card.new(title: "Title from attribute")
    component.with_header { "Header from slot" }

    rendered = render_fragment(component) { "Card body content" }

    # Should render both header slot content and title
    assert_includes rendered.text, "Header from slot"
    assert_includes rendered.text, "Title from attribute"

    # Should have card-title span inside card-body
    title_element = rendered.css(".card-body span.card-title").first
    assert title_element
    assert_equal "Title from attribute", title_element.text

    # Should also render body content
    assert_includes rendered.text, "Card body content"
  end

  def test_card_styling_classes
    component = Decor::Card.new
    rendered = render_fragment(component) { "Content" }

    # Should have daisyUI card classes
    card_element = rendered.css(".card").first
    assert card_element

    # Check for key daisyUI classes
    classes = card_element["class"]
    assert_includes classes, "card"
    assert_includes classes, "bg-base-100"
    assert_includes classes, "shadow-sm"
  end

  def test_card_with_only_header_slot
    component = Decor::Card.new
    component.with_header { "Header only" }

    rendered = render_fragment(component) { "Body content" }

    # Should render header slot content
    assert_includes rendered.text, "Header only"

    # Should not have card-title span since no title provided
    assert_empty rendered.css(".card-body span.card-title")

    # Should render body content
    assert_includes rendered.text, "Body content"
  end

  def test_empty_card
    component = Decor::Card.new
    rendered = render_fragment(component)

    # Should still have card structure
    assert rendered.css(".card").any?
    assert rendered.css(".card-body").any?

    # Should not have card-title span since no title provided
    assert_empty rendered.css(".card-body span.card-title")
  end

  def test_card_with_image_top_position
    component = Decor::Card.new(
      image_url: "https://example.com/image.jpg",
      image_position: :top
    )

    rendered = render_fragment(component) { "Card content" }

    # Should have regular card classes (not flex-row)
    card_element = rendered.css(".card").first
    refute_includes card_element["class"], "flex-row"

    # Should have image with top positioning classes
    image_element = rendered.css("[style*='background-image']").first
    assert image_element
    assert_includes image_element["class"], "rounded-t-box"
    assert_includes image_element["class"], "w-full"
    assert_includes image_element["class"], "h-60"
    assert_includes image_element["style"], "background-image: url('https://example.com/image.jpg')"

    # Should still render content
    assert_includes rendered.text, "Card content"
  end

  def test_card_with_image_bottom_position
    component = Decor::Card.new(
      image_url: "https://example.com/image.jpg",
      image_position: :bottom
    )

    rendered = render_fragment(component) { "Card content" }

    # Should have regular card classes (not flex-row)
    card_element = rendered.css(".card").first
    refute_includes card_element["class"], "flex-row"

    # Should have image with bottom positioning classes
    image_element = rendered.css("[style*='background-image']").first
    assert image_element
    assert_includes image_element["class"], "rounded-b-box"
    assert_includes image_element["class"], "w-full"
    assert_includes image_element["class"], "h-60"
  end

  def test_card_with_image_left_position
    component = Decor::Card.new(
      image_url: "https://example.com/image.jpg",
      image_position: :left
    )

    rendered = render_fragment(component) { "Card content" }

    # Should have flex-row class for horizontal layout
    card_element = rendered.css(".card").first
    assert_includes card_element["class"], "flex-row"

    # Should have image with left positioning classes
    image_element = rendered.css("[style*='background-image']").first
    assert image_element
    assert_includes image_element["class"], "rounded-l-box"
    assert_includes image_element["class"], "w-48"

    # Should have content wrapper with appropriate classes
    content_wrapper = rendered.css(".flex.flex-col.rounded-r-box").first
    assert content_wrapper
    assert_includes content_wrapper["class"], "flex-1"
  end

  def test_card_with_image_right_position
    component = Decor::Card.new(
      image_url: "https://example.com/image.jpg",
      image_position: :right
    )

    rendered = render_fragment(component) { "Card content" }

    # Should have flex-row class for horizontal layout
    card_element = rendered.css(".card").first
    assert_includes card_element["class"], "flex-row"

    # Should have image with right positioning classes
    image_element = rendered.css("[style*='background-image']").first
    assert image_element
    assert_includes image_element["class"], "rounded-r-box"
    assert_includes image_element["class"], "w-48"

    # Should have content wrapper with appropriate classes
    content_wrapper = rendered.css(".flex.flex-col.rounded-l-box").first
    assert content_wrapper
    assert_includes content_wrapper["class"], "flex-1"
  end

  def test_card_without_image_url
    component = Decor::Card.new(image_position: :top)

    rendered = render_fragment(component) { "Card content" }

    # Should not render any image elements
    assert_empty rendered.css("[style*='background-image']")

    # Should still render content normally
    assert_includes rendered.text, "Card content"
    assert rendered.css(".card-body").any?
  end

  def test_card_image_default_position
    component = Decor::Card.new(image_url: "https://example.com/image.jpg")

    rendered = render_fragment(component) { "Card content" }

    # Should default to top position
    image_element = rendered.css("[style*='background-image']").first
    assert image_element
    assert_includes image_element["class"], "rounded-t-box"
  end

  def test_card_with_image_and_title
    component = Decor::Card.new(
      title: "Card Title",
      image_url: "https://example.com/image.jpg",
      image_position: :left
    )

    rendered = render_fragment(component) { "Card content" }

    # Should have both image and title
    assert rendered.css("[style*='background-image']").any?

    title_element = rendered.css(".card-title").first
    assert title_element
    assert_equal "Card Title", title_element.text

    assert_includes rendered.text, "Card content"
  end

  def test_card_with_image_and_header_slot
    component = Decor::Card.new(
      image_url: "https://example.com/image.jpg",
      image_position: :top
    )
    component.with_header { "Header content" }

    rendered = render_fragment(component) { "Body content" }

    # Should have image, header slot, and body content
    assert rendered.css("[style*='background-image']").any?
    assert_includes rendered.text, "Header content"
    assert_includes rendered.text, "Body content"
  end

  def test_image_alt_attribute_stored
    component = Decor::Card.new(
      image_url: "https://example.com/image.jpg",
      image_alt: "Test alt text"
    )

    # Alt text is stored but not used in current background-image implementation
    # This test ensures the attribute is accepted
    assert_equal "Test alt text", component.instance_variable_get(:@image_alt)
  end
end
