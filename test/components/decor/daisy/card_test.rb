# frozen_string_literal: true

require "test_helper"

class Decor::Daisy::CardTest < ActiveSupport::TestCase
  def test_renders_basic_card
    component = Decor::Daisy::Card.new

    rendered = render_fragment(component) { "Card content" }

    assert rendered.css('[class~="decor:d-card"][class~="decor:bg-base-100"][class~="decor:shadow-sm"]').any?

    assert rendered.css('[class~="decor:d-card-body"]').any?
    assert_includes rendered.text, "Card content"
  end

  def test_renders_card_with_header_slot
    component = Decor::Daisy::Card.new
    component.with_header { "Card Header" }

    rendered = render_fragment(component) { "Card body content" }

    assert_includes rendered.text, "Card Header"

    assert_includes rendered.text, "Card body content"

    assert rendered.css('[class~="decor:d-card-body"]').any?
  end

  def test_card_without_header_slot
    component = Decor::Daisy::Card.new

    rendered = render_fragment(component) { "Just body content" }

    assert_includes rendered.text, "Just body content"

    assert rendered.css('[class~="decor:d-card-body"]').any?
  end

  def test_renders_card_with_title
    component = Decor::Daisy::Card.new(title: "My Card Title")

    rendered = render_fragment(component) { "Card body content" }

    title_element = rendered.css('[class~="decor:d-card-body"] span[class~="decor:d-card-title"]').first
    assert title_element
    assert_equal "My Card Title", title_element.text

    assert_includes rendered.text, "Card body content"

    assert rendered.css('[class~="decor:d-card-body"]').any?
  end

  def test_card_with_both_header_slot_and_title
    component = Decor::Daisy::Card.new(title: "Title from attribute")
    component.with_header { "Header from slot" }

    rendered = render_fragment(component) { "Card body content" }

    assert_includes rendered.text, "Header from slot"
    assert_includes rendered.text, "Title from attribute"

    title_element = rendered.css('[class~="decor:d-card-body"] span[class~="decor:d-card-title"]').first
    assert title_element
    assert_equal "Title from attribute", title_element.text

    assert_includes rendered.text, "Card body content"
  end

  def test_card_styling_classes
    component = Decor::Daisy::Card.new
    rendered = render_fragment(component) { "Content" }

    card_element = rendered.css('[class~="decor:d-card"]').first
    assert card_element

    classes = card_element["class"]
    assert_includes classes, "decor:d-card"
    assert_includes classes, "decor:bg-base-100"
    assert_includes classes, "decor:shadow-sm"
  end

  def test_card_with_only_header_slot
    component = Decor::Daisy::Card.new
    component.with_header { "Header only" }

    rendered = render_fragment(component) { "Body content" }

    assert_includes rendered.text, "Header only"

    assert_empty rendered.css('[class~="decor:d-card-body"] span[class~="decor:d-card-title"]')

    assert_includes rendered.text, "Body content"
  end

  def test_empty_card
    component = Decor::Daisy::Card.new
    rendered = render_fragment(component)

    assert rendered.css('[class~="decor:d-card"]').any?
    assert rendered.css('[class~="decor:d-card-body"]').any?

    assert_empty rendered.css('[class~="decor:d-card-body"] span[class~="decor:d-card-title"]')
  end

  def test_card_with_image_top_position
    component = Decor::Daisy::Card.new(
      image_url: "https://example.com/image.jpg",
      image_position: :top
    )

    rendered = render_fragment(component) { "Card content" }

    card_element = rendered.css('[class~="decor:d-card"]').first
    refute_includes card_element["class"], "decor:flex-row"

    image_element = rendered.css("[style*='background-image']").first
    assert image_element
    assert_includes image_element["class"], "decor:rounded-t-box"
    assert_includes image_element["class"], "decor:w-full"
    assert_includes image_element["class"], "decor:h-60"
    assert_includes image_element["style"], "background-image: url('https://example.com/image.jpg')"

    assert_includes rendered.text, "Card content"
  end

  def test_card_with_image_bottom_position
    component = Decor::Daisy::Card.new(
      image_url: "https://example.com/image.jpg",
      image_position: :bottom
    )

    rendered = render_fragment(component) { "Card content" }

    card_element = rendered.css('[class~="decor:d-card"]').first
    refute_includes card_element["class"], "decor:flex-row"

    image_element = rendered.css("[style*='background-image']").first
    assert image_element
    assert_includes image_element["class"], "decor:rounded-b-box"
    assert_includes image_element["class"], "decor:w-full"
    assert_includes image_element["class"], "decor:h-60"
  end

  def test_card_with_image_left_position
    component = Decor::Daisy::Card.new(
      image_url: "https://example.com/image.jpg",
      image_position: :left
    )

    rendered = render_fragment(component) { "Card content" }

    card_element = rendered.css('[class~="decor:d-card"]').first
    assert_includes card_element["class"], "decor:flex-row"

    image_element = rendered.css("[style*='background-image']").first
    assert image_element
    assert_includes image_element["class"], "decor:rounded-l-box"
    assert_includes image_element["class"], "decor:w-48"

    content_wrapper = rendered.css('[class~="decor:flex"][class~="decor:flex-col"][class~="decor:rounded-r-box"]').first
    assert content_wrapper
    assert_includes content_wrapper["class"], "decor:flex-1"
  end

  def test_card_with_image_right_position
    component = Decor::Daisy::Card.new(
      image_url: "https://example.com/image.jpg",
      image_position: :right
    )

    rendered = render_fragment(component) { "Card content" }

    card_element = rendered.css('[class~="decor:d-card"]').first
    assert_includes card_element["class"], "decor:flex-row"

    image_element = rendered.css("[style*='background-image']").first
    assert image_element
    assert_includes image_element["class"], "decor:rounded-r-box"
    assert_includes image_element["class"], "decor:w-48"

    content_wrapper = rendered.css('[class~="decor:flex"][class~="decor:flex-col"][class~="decor:rounded-l-box"]').first
    assert content_wrapper
    assert_includes content_wrapper["class"], "decor:flex-1"
  end

  def test_card_without_image_url
    component = Decor::Daisy::Card.new(image_position: :top)

    rendered = render_fragment(component) { "Card content" }

    assert_empty rendered.css("[style*='background-image']")

    assert_includes rendered.text, "Card content"
    assert rendered.css('[class~="decor:d-card-body"]').any?
  end

  def test_card_image_default_position
    component = Decor::Daisy::Card.new(image_url: "https://example.com/image.jpg")

    rendered = render_fragment(component) { "Card content" }

    image_element = rendered.css("[style*='background-image']").first
    assert image_element
    assert_includes image_element["class"], "decor:rounded-t-box"
  end

  def test_card_with_image_and_title
    component = Decor::Daisy::Card.new(
      title: "Card Title",
      image_url: "https://example.com/image.jpg",
      image_position: :left
    )

    rendered = render_fragment(component) { "Card content" }

    assert rendered.css("[style*='background-image']").any?

    title_element = rendered.css('[class~="decor:d-card-title"]').first
    assert title_element
    assert_equal "Card Title", title_element.text

    assert_includes rendered.text, "Card content"
  end

  def test_card_with_image_and_header_slot
    component = Decor::Daisy::Card.new(
      image_url: "https://example.com/image.jpg",
      image_position: :top
    )
    component.with_header { "Header content" }

    rendered = render_fragment(component) { "Body content" }

    assert rendered.css("[style*='background-image']").any?
    assert_includes rendered.text, "Header content"
    assert_includes rendered.text, "Body content"
  end

  def test_image_alt_attribute_stored
    component = Decor::Daisy::Card.new(
      image_url: "https://example.com/image.jpg",
      image_alt: "Test alt text"
    )

    assert_equal "Test alt text", component.instance_variable_get(:@image_alt)
  end

  def test_card_with_color_attribute
    card = ::Decor::Daisy::Card.new(color: :primary)
    output = card.call
    assert_includes output, "decor:bg-primary"
    assert_includes output, "decor:text-primary-content"
  end

  def test_card_with_size_attribute
    card = ::Decor::Daisy::Card.new(size: :xs)
    output = card.call
    assert_includes output, "decor:d-card-xs"
  end

  def test_card_with_style_outlined
    card = ::Decor::Daisy::Card.new(style: :outlined, color: :primary)
    output = card.call
    assert_includes output, "decor:border"
    assert_includes output, "decor:border-primary"
    assert_includes output, "decor:bg-base-100"
  end

  def test_card_with_style_ghost
    card = ::Decor::Daisy::Card.new(style: :ghost)
    output = card.call
    assert_includes output, "decor:shadow-none"
  end

  def test_card_defaults_to_base_color_and_filled_style
    card = ::Decor::Daisy::Card.new
    output = card.call
    assert_includes output, "decor:bg-base-100"
    assert_includes output, "decor:shadow-sm"
  end
end
