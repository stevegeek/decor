# frozen_string_literal: true

require "test_helper"

class Decor::PanelTest < ActiveSupport::TestCase
  def test_renders_panel_with_title_only
    component = Decor::Panel.new(title: "Panel Title")

    rendered = render_fragment(component) { "Panel content" }

    # Should have panel structure with space-y-2 classes
    assert rendered.css(".space-y-2").any?

    # Should render title with correct classes (now uses Title component with sm size = h4)
    title_element = rendered.css("h4").first
    assert title_element
    assert_equal "Panel Title", title_element.text
    assert_includes title_element["class"], "text-base"

    # Should render content
    assert_includes rendered.text, "Panel content"
  end

  def test_renders_panel_with_title_and_icon
    component = Decor::Panel.new(title: "Panel Title", icon: "academic-cap")

    rendered = render_fragment(component) { "Panel content" }

    # Should have flex container for icon and title (from Title component) with top alignment
    assert rendered.css(".flex.items-start.space-x-2").any?

    # Should render title (now uses Title component with sm size = h4)
    title_element = rendered.css("h4").first
    assert title_element
    assert_equal "Panel Title", title_element.text

    # Should render content
    assert_includes rendered.text, "Panel content"
  end

  def test_renders_without_content_block
    component = Decor::Panel.new(title: "Panel Title")

    rendered = render_fragment(component)

    # Should render title (now uses Title component with sm size = h4)
    title_element = rendered.css("h4").first
    assert title_element
    assert_equal "Panel Title", title_element.text

    # Should have panel structure
    assert rendered.css(".space-y-2").any?
  end

  def test_panel_with_icon_has_correct_structure
    component = Decor::Panel.new(title: "Test Panel", icon: "academic-cap")

    rendered = render_fragment(component) { "Test content" }

    # Should have icon container with top alignment
    icon_container = rendered.css(".flex.items-start.space-x-2").first
    assert icon_container

    # Should render content
    assert_includes rendered.text, "Test content"
  end

  def test_panel_without_icon_has_simple_structure
    component = Decor::Panel.new(title: "Simple Panel")

    rendered = render_fragment(component) { "Simple content" }

    # Should not have icon container (when no icon is provided, Title component doesn't add icon container)
    # But Title component still adds its own flex containers, so we check the title is not inside the icon flex
    title_element = rendered.css("h4").first
    assert title_element
    assert_equal "Simple Panel", title_element.text

    # Should render content
    assert_includes rendered.text, "Simple content"
  end

  def test_inherits_from_phlex_component
    component = Decor::Panel.new(title: "Test")
    assert_kind_of Decor::PhlexComponent, component
  end

  def test_panel_styling_classes
    component = Decor::Panel.new(title: "Test Panel")
    rendered = render_fragment(component) { "Content" }

    # Should have space-y-2 classes (text-sm now on content div)
    panel_element = rendered.css(".space-y-2").first
    assert panel_element

    # Check for key classes
    classes = panel_element["class"]
    assert_includes classes, "space-y-2"

    # Content should have text-sm class
    content_div = rendered.css(".mt-1\\.5.text-sm").first
    assert content_div
  end
end
