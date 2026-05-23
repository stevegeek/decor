# frozen_string_literal: true

require "test_helper"

class Decor::Daisy::PanelTest < ActiveSupport::TestCase
  def test_renders_panel_with_title_only
    component = Decor::Daisy::Panel.new(title: "Panel Title")

    rendered = render_fragment(component) { "Panel content" }

    assert rendered.css('[class~="decor:space-y-2"]').any?

    title_element = rendered.css("h4").first
    assert title_element
    assert_equal "Panel Title", title_element.text
    assert_includes title_element["class"], "decor:text-base"

    assert_includes rendered.text, "Panel content"
  end

  def test_renders_panel_with_title_and_icon
    component = Decor::Daisy::Panel.new(title: "Panel Title", icon: "academic-cap")

    rendered = render_fragment(component) { "Panel content" }

    assert rendered.css('[class~="decor:flex"][class~="decor:items-start"][class~="decor:space-x-2"]').any?

    title_element = rendered.css("h4").first
    assert title_element
    assert_equal "Panel Title", title_element.text

    assert_includes rendered.text, "Panel content"
  end

  def test_renders_without_content_block
    component = Decor::Daisy::Panel.new(title: "Panel Title")

    rendered = render_fragment(component)

    title_element = rendered.css("h4").first
    assert title_element
    assert_equal "Panel Title", title_element.text

    assert rendered.css('[class~="decor:space-y-2"]').any?
  end

  def test_panel_with_icon_has_correct_structure
    component = Decor::Daisy::Panel.new(title: "Test Panel", icon: "academic-cap")

    rendered = render_fragment(component) { "Test content" }

    icon_container = rendered.css('[class~="decor:flex"][class~="decor:items-start"][class~="decor:space-x-2"]').first
    assert icon_container

    assert_includes rendered.text, "Test content"
  end

  def test_panel_without_icon_has_simple_structure
    component = Decor::Daisy::Panel.new(title: "Simple Panel")

    rendered = render_fragment(component) { "Simple content" }

    title_element = rendered.css("h4").first
    assert title_element
    assert_equal "Simple Panel", title_element.text

    assert_includes rendered.text, "Simple content"
  end

  def test_inherits_from_phlex_component
    component = Decor::Daisy::Panel.new(title: "Test")
    assert_kind_of Decor::PhlexComponent, component
  end

  def test_panel_styling_classes
    component = Decor::Daisy::Panel.new(title: "Test Panel")
    rendered = render_fragment(component) { "Content" }

    panel_element = rendered.css('[class~="decor:space-y-2"]').first
    assert panel_element

    classes = panel_element["class"]
    assert_includes classes, "decor:space-y-2"

    content_div = rendered.css('[class~="decor:mt-1.5"][class~="decor:text-sm"]').first
    assert content_div
  end
end
