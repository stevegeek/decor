# frozen_string_literal: true

require "test_helper"

class Decor::Daisy::CardHeaderTest < ActiveSupport::TestCase
  def test_renders_with_title_only
    component = Decor::Daisy::CardHeader.new(title: "Test Title")

    rendered = render_fragment(component)

    h3 = rendered.css("h3").first
    assert h3
    assert_equal "Test Title", h3.text
    assert rendered.css('[class~="decor:d-card-header"]').any?
  end

  def test_renders_with_title_and_subtitle
    component = Decor::Daisy::CardHeader.new(
      title: "Test Title",
      subtitle: "Test Subtitle"
    )

    rendered = render_fragment(component)

    h3 = rendered.css("h3").first
    assert h3
    assert_equal "Test Title", h3.text
    p = rendered.css("p").first
    assert p
    assert_equal "Test Subtitle", p.text
  end

  def test_renders_with_icon
    component = Decor::Daisy::CardHeader.new(
      title: "Test Title",
      icon: "home"
    )

    rendered = render_fragment(component)

    h3 = rendered.css("h3").first
    assert h3
    assert_equal "Test Title", h3.text
    assert rendered.css("svg").any?
  end

  def test_renders_with_actions
    component = Decor::Daisy::CardHeader.new(title: "Test Title") do |header|
      header.with_actions do
        "<button>Action</button>".html_safe
      end
    end

    rendered = render_fragment(component)

    h3 = rendered.css("h3").first
    assert h3
    assert_equal "Test Title", h3.text
    button = rendered.css("button").first
    assert button
    assert_equal "Action", button.text
  end

  def test_renders_with_meta_content
    component = Decor::Daisy::CardHeader.new(title: "Test Title") do |header|
      header.with_meta do
        "<span>Meta content</span>".html_safe
      end
    end

    rendered = render_fragment(component)

    h3 = rendered.css("h3").first
    assert h3
    assert_equal "Test Title", h3.text
    span = rendered.css("span").first
    assert span
    assert_equal "Meta content", span.text
  end

  def test_size_variants
    [:xs, :sm, :md, :lg, :xl].each do |size|
      component = Decor::Daisy::CardHeader.new(title: "Test Title", size: size)

      rendered = render_fragment(component)

      h3 = rendered.css("h3").first
      assert h3
      assert_equal "Test Title", h3.text
    end
  end

  def test_default_size_is_md
    component = Decor::Daisy::CardHeader.new(title: "Test Title")

    rendered = render_fragment(component)

    h3 = rendered.css('h3[class~="decor:text-lg"]').first
    assert h3
    assert_equal "Test Title", h3.text
  end
end
