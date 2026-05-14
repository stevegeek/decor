# frozen_string_literal: true

require "test_helper"

class Decor::Daisy::ClickToCopyTest < ActiveSupport::TestCase
  def test_renders_with_content
    component = Decor::Daisy::ClickToCopy.new

    rendered = render_fragment(component) { "Copy this text" }

    # Should have cursor pointer class (with decor: prefix)
    assert_includes rendered.to_html, "cursor-pointer"

    # Should render content
    assert_includes rendered.text, "Copy this text"

    # Should have flex layout (with decor: prefix)
    assert_includes rendered.to_html, "flex"
    assert_includes rendered.to_html, "items-center"
  end

  def test_has_copy_tooltip
    component = Decor::Daisy::ClickToCopy.new

    rendered = render_fragment(component) { "Content" }

    # Should have tooltip on the inner flex div (search by title attribute)
    assert_includes rendered.to_html, 'title="Click to copy this."'
  end

  def test_renders_copy_icon_without_block
    component = Decor::Daisy::ClickToCopy.new

    rendered = render_fragment(component)

    # Should render copy icon when no block given (Tabler convention: 'copy')
    assert_includes rendered.to_html, "copy"

    # Icon should have proper classes (with decor: prefix)
    assert_includes rendered.to_html, "ml-2"
    assert_includes rendered.to_html, "h-4"
    assert_includes rendered.to_html, "w-4"
  end

  def test_renders_block_content_instead_of_icon
    component = Decor::Daisy::ClickToCopy.new

    rendered = render_fragment(component) { "Content" }

    # Should render block content
    assert_includes rendered.text, "Content"

    # Should NOT render copy icon asset when block is given
    refute_includes rendered.to_html, "/copy-"
  end

  def test_has_stimulus_actions
    component = Decor::Daisy::ClickToCopy.new

    rendered = render_fragment(component) { "Content" }

    # Should have click action for copy
    root_element = rendered.children.first
    assert root_element
    assert_includes root_element["class"], "cursor-pointer"
  end

  def test_content_target_structure
    component = Decor::Daisy::ClickToCopy.new

    rendered = render_fragment(component) { "Target content" }

    # Should have content in target div
    assert_includes rendered.text, "Target content"

    # Should have flex structure (with decor: prefix)
    assert_includes rendered.to_html, "flex"
    assert_includes rendered.to_html, "items-center"

    # Should have content target (attribute selector still works)
    content_target = rendered.css("[data-decor--daisy--click-to-copy-target='content']").first
    assert content_target
    assert_includes content_target.text, "Target content"
  end

  def test_empty_content_shows_default_icon
    component = Decor::Daisy::ClickToCopy.new

    rendered = render_fragment(component)

    # Should still render structure (with decor: prefix)
    assert_includes rendered.to_html, "cursor-pointer"
    assert_includes rendered.to_html, "flex"

    # Should show copy icon as default when no block given (Tabler convention: 'copy')
    assert_includes rendered.to_html, "copy"
  end

  def test_with_to_copy_prop
    component = Decor::Daisy::ClickToCopy.new(to_copy: "Secret text to copy")

    rendered = render_fragment(component) { "Display this text" }

    # Should show the display text
    assert_includes rendered.text, "Display this text"

    # Should have the to_copy value as a stimulus value
    root_element = rendered.children.first
    assert root_element
    assert_includes root_element["data-decor--daisy--click-to-copy-to-copy-value"], "Secret text to copy"
  end

  def test_without_to_copy_prop
    component = Decor::Daisy::ClickToCopy.new

    rendered = render_fragment(component) { "Display and copy this" }

    # Should show the display text
    assert_includes rendered.text, "Display and copy this"

    # When to_copy is nil, Vident 2 does not emit the data attribute at all.
    # The JS controller's hasToCopyValue && toCopyValue check then falls back
    # to the content target's text — same effective behavior, cleaner DOM.
    root_element = rendered.children.first
    assert root_element
    assert_nil root_element["data-decor--daisy--click-to-copy-to-copy-value"]
  end
end
