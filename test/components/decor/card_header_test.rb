# frozen_string_literal: true

require "test_helper"

class Decor::CardHeaderTest < ViewComponent::TestCase
  def test_renders_with_title_only
    component = Decor::CardHeader.new(title: "Test Title")

    render_inline(component)

    assert_selector "h3", text: "Test Title"
    assert_selector ".card-header"
  end

  def test_renders_with_title_and_subtitle
    component = Decor::CardHeader.new(
      title: "Test Title",
      subtitle: "Test Subtitle"
    )

    render_inline(component)

    assert_selector "h3", text: "Test Title"
    assert_selector "p", text: "Test Subtitle"
  end

  def test_renders_with_icon
    component = Decor::CardHeader.new(
      title: "Test Title",
      icon: "home"
    )

    render_inline(component)

    assert_selector "h3", text: "Test Title"
    assert_selector "svg"
  end

  def test_renders_with_actions
    component = Decor::CardHeader.new(title: "Test Title") do |header|
      header.with_actions do
        "<button>Action</button>".html_safe
      end
    end

    render_inline(component)

    assert_selector "h3", text: "Test Title"
    assert_selector "button", text: "Action"
  end

  def test_renders_with_meta_content
    component = Decor::CardHeader.new(title: "Test Title") do |header|
      header.with_meta do
        "<span>Meta content</span>".html_safe
      end
    end

    render_inline(component)

    assert_selector "h3", text: "Test Title"
    assert_selector "span", text: "Meta content"
  end

  def test_size_variants
    [:xs, :sm, :md, :lg, :xl].each do |size|
      component = Decor::CardHeader.new(title: "Test Title", size: size)

      render_inline(component)

      assert_selector "h3", text: "Test Title"
    end
  end

  def test_default_size_is_md
    component = Decor::CardHeader.new(title: "Test Title")

    render_inline(component)

    assert_selector "h3.text-lg", text: "Test Title"
  end
end
