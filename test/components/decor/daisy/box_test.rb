# frozen_string_literal: true

require "test_helper"

class Decor::Daisy::BoxTest < ActiveSupport::TestCase
  def test_renders_basic_box_with_title_and_description
    component = Decor::Daisy::Box.new(
      title: "Test Title",
      description: "Test description"
    )

    rendered = render_fragment(component)

    assert rendered.css(".card.card-bordered.bg-base-100").any?

    assert_includes rendered.text, "Test Title"
    assert_includes rendered.text, "Test description"

    assert rendered.css("h2.card-title").any?

    assert rendered.css("p.text-base-content\\/70").any?
  end

  def test_renders_box_with_html_title_slot
    component = Decor::Daisy::Box.new(description: "Test description")
    component.html_title { "Custom <strong>HTML</strong> Title".html_safe }

    rendered = render_fragment(component)

    assert rendered.css("strong").any?
    assert_includes rendered.text, "Custom HTML Title"
  end

  def test_renders_box_with_left_slot
    component = Decor::Daisy::Box.new(title: "Title", description: "Description")
    component.left { "Left content" }

    rendered = render_fragment(component)

    assert_includes rendered.text, "Left content"

    refute_includes rendered.text, "Title"
    refute_includes rendered.text, "Description"
  end

  def test_renders_box_with_right_slot
    component = Decor::Daisy::Box.new(title: "Title", description: "Description")
    component.right { "Right content" }

    rendered = render_fragment(component)

    assert_includes rendered.text, "Title"
    assert_includes rendered.text, "Description"
    assert_includes rendered.text, "Right content"
  end

  def test_renders_box_with_block_content
    component = Decor::Daisy::Box.new(title: "Title", description: "Description")

    rendered = render_fragment(component) { "Block content" }

    assert_includes rendered.text, "Title"
    assert_includes rendered.text, "Description"
    assert_includes rendered.text, "Block content"

    assert rendered.css("div.card-body").any?
  end

  def test_renders_box_with_both_slots
    component = Decor::Daisy::Box.new(title: "Title", description: "Description")
    component.left { "Left content" }
    component.right { "Right content" }

    rendered = render_fragment(component)

    assert_includes rendered.text, "Left content"
    assert_includes rendered.text, "Right content"

    refute_includes rendered.text, "Title"
    refute_includes rendered.text, "Description"

    assert rendered.css("div.flex.justify-between.items-start").any?
    assert rendered.css("div.flex-1").any?
    assert rendered.css("div.flex-none").any?
  end

  def test_box_styling_classes
    component = Decor::Daisy::Box.new(title: "Title", description: "Description")
    rendered = render_fragment(component)

    card_element = rendered.css(".card").first
    assert card_element

    classes = card_element["class"]
    assert_includes classes, "card"
    assert_includes classes, "card-bordered"
    assert_includes classes, "bg-base-100"
  end
end
