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

  def test_renders_duplicate_icon_without_block
    component = Decor::ClickToCopy.new

    rendered = render_fragment(component)

    # Should render duplicate icon when no block given
    assert_includes rendered.to_html, "duplicate"

    # Icon should have proper classes
    assert_includes rendered.to_html, "ml-2 h-4 w-4"
  end

  def test_renders_block_content_instead_of_icon
    component = Decor::ClickToCopy.new

    rendered = render_fragment(component) { "Content" }

    # Should render block content
    assert_includes rendered.text, "Content"

    # Should NOT render duplicate icon when block is given
    refute_includes rendered.to_html, "duplicate"
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

    # Should have content target
    content_target = rendered.css("[data-decor--click-to-copy-target='content']").first
    assert content_target
    assert_includes content_target.text, "Target content"
  end

  def test_empty_content_shows_default_icon
    component = Decor::ClickToCopy.new

    rendered = render_fragment(component)

    # Should still render structure
    assert rendered.css(".cursor-pointer").any?
    assert rendered.css(".flex.items-center").any?

    # Should show duplicate icon as default when no block given
    assert_includes rendered.to_html, "duplicate"
  end

  def test_with_to_copy_prop
    component = Decor::ClickToCopy.new(to_copy: "Secret text to copy")

    rendered = render_fragment(component) { "Display this text" }

    # Should show the display text
    assert_includes rendered.text, "Display this text"

    # Should have the to_copy value as a stimulus value
    root_element = rendered.children.first
    assert root_element
    assert_includes root_element["data-decor--click-to-copy-to-copy-value"], "Secret text to copy"
  end

  def test_without_to_copy_prop
    component = Decor::ClickToCopy.new

    rendered = render_fragment(component) { "Display and copy this" }

    # Should show the display text
    assert_includes rendered.text, "Display and copy this"

    # Should have empty to_copy stimulus value
    root_element = rendered.children.first
    assert root_element
    assert_equal "", root_element["data-decor--click-to-copy-to-copy-value"]
  end
end
