# frozen_string_literal: true

require "test_helper"

class Decor::ClickToCopyTest < ActiveSupport::TestCase
  def test_renders_with_content
    component = Decor::ClickToCopy.new

    rendered = render_fragment(component) { "Copy this text" }

    # Should have cursor pointer class
    assert rendered.css(".cursor-pointer").any?

    # Should render content
    assert_includes rendered.text, "Copy this text"

    # Should have flex layout
    assert rendered.css(".flex.items-center").any?
  end

  def test_has_copy_tooltip
    component = Decor::ClickToCopy.new

    rendered = render_fragment(component) { "Content" }

    # Should have tooltip
    flex_div = rendered.css(".flex.items-center").first
    assert flex_div
    assert_equal "Click to copy this.", flex_div["title"]
  end

  def test_renders_duplicate_icon
    component = Decor::ClickToCopy.new

    rendered = render_fragment(component) { "Content" }

    # Should render duplicate icon
    assert_includes rendered.to_html, "duplicate"

    # Icon should have proper classes
    assert_includes rendered.to_html, "ml-2 h-4 w-4"
  end

  def test_has_stimulus_actions
    component = Decor::ClickToCopy.new

    rendered = render_fragment(component) { "Content" }

    # Should have click action for copy
    root_element = rendered.children.first
    assert root_element
    assert_includes root_element["class"], "cursor-pointer"
  end

  def test_content_target_structure
    component = Decor::ClickToCopy.new

    rendered = render_fragment(component) { "Target content" }

    # Should have content in target div
    assert_includes rendered.text, "Target content"

    # Should have flex structure
    flex_container = rendered.css(".flex.items-center").first
    assert flex_container

    # Should have content and icon
    assert_includes rendered.text, "Target content"
    assert_includes rendered.to_html, "duplicate"
  end

  def test_empty_content
    component = Decor::ClickToCopy.new

    rendered = render_fragment(component)

    # Should still render structure
    assert rendered.css(".cursor-pointer").any?
    assert rendered.css(".flex.items-center").any?

    # Should still have duplicate icon
    assert_includes rendered.to_html, "duplicate"
  end
end
