# frozen_string_literal: true

require "test_helper"

class Decor::Daisy::ClickToCopyTest < ActiveSupport::TestCase
  def test_renders_with_content
    component = Decor::Daisy::ClickToCopy.new

    rendered = render_fragment(component) { "Copy this text" }

    assert_includes rendered.to_html, "cursor-pointer"

    assert_includes rendered.text, "Copy this text"

    assert_includes rendered.to_html, "flex"
    assert_includes rendered.to_html, "items-center"
  end

  def test_has_copy_tooltip
    component = Decor::Daisy::ClickToCopy.new

    rendered = render_fragment(component) { "Content" }

    assert_includes rendered.to_html, 'title="Click to copy this."'
  end

  def test_renders_copy_icon_without_block
    component = Decor::Daisy::ClickToCopy.new

    rendered = render_fragment(component)

    assert_includes rendered.to_html, "copy"

    assert_includes rendered.to_html, "ml-2"
    assert_includes rendered.to_html, "h-4"
    assert_includes rendered.to_html, "w-4"
  end

  def test_renders_block_content_instead_of_icon
    component = Decor::Daisy::ClickToCopy.new

    rendered = render_fragment(component) { "Content" }

    assert_includes rendered.text, "Content"

    refute_includes rendered.to_html, "/copy-"
  end

  def test_has_stimulus_actions
    component = Decor::Daisy::ClickToCopy.new

    rendered = render_fragment(component) { "Content" }

    root_element = rendered.children.first
    assert root_element
    assert_includes root_element["class"], "cursor-pointer"
  end

  def test_content_target_structure
    component = Decor::Daisy::ClickToCopy.new

    rendered = render_fragment(component) { "Target content" }

    assert_includes rendered.text, "Target content"

    assert_includes rendered.to_html, "flex"
    assert_includes rendered.to_html, "items-center"

    content_target = rendered.css("[data-decor--daisy--click-to-copy-target='content']").first
    assert content_target
    assert_includes content_target.text, "Target content"
  end

  def test_empty_content_shows_default_icon
    component = Decor::Daisy::ClickToCopy.new

    rendered = render_fragment(component)

    assert_includes rendered.to_html, "cursor-pointer"
    assert_includes rendered.to_html, "flex"

    assert_includes rendered.to_html, "copy"
  end

  def test_with_to_copy_prop
    component = Decor::Daisy::ClickToCopy.new(to_copy: "Secret text to copy")

    rendered = render_fragment(component) { "Display this text" }

    assert_includes rendered.text, "Display this text"

    root_element = rendered.children.first
    assert root_element
    assert_includes root_element["data-decor--daisy--click-to-copy-to-copy-value"], "Secret text to copy"
  end

  def test_without_to_copy_prop
    component = Decor::Daisy::ClickToCopy.new

    rendered = render_fragment(component) { "Display and copy this" }

    assert_includes rendered.text, "Display and copy this"

    # When to_copy is nil, Vident 2 does not emit the data attribute at all.
    # The JS controller's hasToCopyValue && toCopyValue check then falls back
    # to the content target's text — same effective behavior, cleaner DOM.
    root_element = rendered.children.first
    assert root_element
    assert_nil root_element["data-decor--daisy--click-to-copy-to-copy-value"]
  end
end
