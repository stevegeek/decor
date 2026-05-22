# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::BoxTest < ActiveSupport::TestCase
  test "root has suite surface chrome" do
    html = render_component(::Decor::Suite::Box.new(title: "T"))
    assert_includes html, "decor:bg-suite-gray-25"
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:rounded-suite-card"
    assert_includes html, "decor:flex"
    assert_includes html, "decor:items-center"
    assert_includes html, "decor:justify-between"
  end

  test "renders title with suite-section-title typography" do
    html = render_component(::Decor::Suite::Box.new(title: "My Title"))
    assert_includes html, "My Title"
    assert_includes html, "decor:suite-section-title"
    assert_includes html, "decor:text-gray-900"
  end

  test "renders description with suite-description typography" do
    html = render_component(::Decor::Suite::Box.new(title: "T", description: "Helper text"))
    assert_includes html, "Helper text"
    assert_includes html, "decor:suite-description"
    assert_includes html, "decor:text-gray-500"
  end

  test "html_title slot replaces plain title and renders block markup" do
    html = render_component(::Decor::Suite::Box.new(title: "should-not-appear", description: "D")) do |box|
      box.html_title { "<em>fancy-heading</em>".html_safe }
    end
    assert_includes html, "fancy-heading"
    assert_includes html, "<em>"
    refute_includes html, "should-not-appear"
  end

  test "left slot replaces title + description column entirely" do
    html = render_component(::Decor::Suite::Box.new(title: "hidden-title", description: "hidden-desc")) do |box|
      box.left { "left-slot-content" }
    end
    assert_includes html, "left-slot-content"
    refute_includes html, "hidden-title"
    refute_includes html, "hidden-desc"
  end

  test "right slot renders inside actions cluster with shrink-0 and gap-2" do
    html = render_component(::Decor::Suite::Box.new(title: "T")) do |box|
      box.right { "right-slot-content" }
    end
    assert_includes html, "right-slot-content"
    assert_includes html, "decor:shrink-0"
    assert_includes html, "decor:gap-2"
  end

  test "block content (without right slot) populates the actions cluster" do
    html = render_component(::Decor::Suite::Box.new(title: "T")) { "block-actions".html_safe }
    assert_includes html, "block-actions"
    assert_includes html, "decor:shrink-0"
  end

  test "right slot takes precedence over block content" do
    html = render_component(::Decor::Suite::Box.new(title: "T")) do |box|
      box.right { "right-wins" }
      "block-loses".html_safe
    end
    assert_includes html, "right-wins"
    refute_includes html, "block-loses"
  end

  test "both left and right slots render side-by-side" do
    html = render_component(::Decor::Suite::Box.new) do |box|
      box.left { "L-side" }
      box.right { "R-side" }
    end
    assert_includes html, "L-side"
    assert_includes html, "R-side"
    assert_includes html, "decor:flex-1"
    assert_includes html, "decor:min-w-0"
    assert_includes html, "decor:shrink-0"
  end

  test "uses suite tokens (no daisy semantic colors or raw shorthands)" do
    html = render_component(::Decor::Suite::Box.new(title: "T", description: "D"))
    refute_includes html, "decor:rounded-md"
    refute_includes html, "decor:rounded-lg"
    refute_includes html, "decor:border-black/10"
    refute_includes html, "decor:bg-base-100"
    refute_includes html, "decor:bg-gray-25\""
  end
end
