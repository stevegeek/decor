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
end
