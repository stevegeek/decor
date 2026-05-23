# frozen_string_literal: true

require "test_helper"

class ::Decor::Daisy::PropertyListTest < ActiveSupport::TestCase
  test "renders surface chrome with daisy base tokens" do
    html = render_component(::Decor::Daisy::PropertyList.new) do |list|
      list.with_section { "x".html_safe }
    end
    assert_includes html, "decor:bg-base-100"
    assert_includes html, "decor:border-base-300"
    assert_includes html, "decor:rounded-lg"
  end

  test "renders root with daisy property-list identifier" do
    html = render_component(::Decor::Daisy::PropertyList.new) do |list|
      list.with_section { "x".html_safe }
    end
    assert_includes html, "decor--daisy--property-list"
  end

  test "renders title with daisy h3 typography" do
    html = render_component(::Decor::Daisy::PropertyList.new(title: "Details")) do |list|
      list.with_section { "row".html_safe }
    end
    assert_includes html, "Details"
    assert_includes html, "<h3"
    assert_includes html, "decor:font-semibold"
  end

  test "renders CTA block right-aligned in the title row" do
    html = render_component(::Decor::Daisy::PropertyList.new(title: "Details")) do |list|
      list.with_cta { '<button data-testid="cta">Edit</button>'.html_safe }
      list.with_section { "row".html_safe }
    end
    assert_includes html, 'data-testid="cta"'
    assert_includes html, "decor:shrink-0"
    assert_includes html, "decor:justify-between"
  end

  test "kicker renders with uppercase tracking-wider typography" do
    html = render_component(::Decor::Daisy::PropertyList.new) do |list|
      list.with_section(kicker: "Address") { "row".html_safe }
    end
    assert_includes html, "Address"
    assert_includes html, "decor:uppercase"
    assert_includes html, "decor:tracking-wider"
  end

  test "second section gets a top border divider, first does not" do
    html = render_component(::Decor::Daisy::PropertyList.new) do |list|
      list.with_section { '<div data-testid="s1">a</div>'.html_safe }
      list.with_section { '<div data-testid="s2">b</div>'.html_safe }
    end
    s1_at = html.index('data-testid="s1"')
    s2_at = html.index('data-testid="s2"')
    assert s1_at && s2_at
    divider_at = html.index("decor:border-t decor:border-base-300")
    assert divider_at, "expected divider class string between sections"
    assert s1_at < divider_at, "divider sits after first section"
    assert divider_at < s2_at, "divider sits before second section"
  end

  test "rows layout (default) does not wrap section contents in a grid" do
    html = render_component(::Decor::Daisy::PropertyList.new) do |list|
      list.with_section { "row".html_safe }
    end
    refute_includes html, "decor:grid-cols-3"
  end

  test "grid layout wraps section contents in grid with default 3 columns" do
    html = render_component(::Decor::Daisy::PropertyList.new(layout: :grid)) do |list|
      list.with_section { "row".html_safe }
    end
    assert_includes html, "decor:grid"
    assert_includes html, "decor:grid-cols-3"
    assert_includes html, "decor:gap-y-3"
    assert_includes html, "decor:gap-x-6"
  end

  test "grid layout honours custom column count" do
    html = render_component(::Decor::Daisy::PropertyList.new(layout: :grid, columns: 4)) do |list|
      list.with_section { "row".html_safe }
    end
    assert_includes html, "decor:grid-cols-4"
  end

  test "section block contents are emitted into the section body" do
    html = render_component(::Decor::Daisy::PropertyList.new(title: "User")) do |list|
      list.with_section do
        '<div data-testid="row-phone">Phone: 555-1234</div>'.html_safe
      end
      list.with_section(kicker: "Contact") do
        '<div data-testid="row-email">Email: u@example.com</div>'.html_safe
      end
    end
    assert_includes html, 'data-testid="row-phone"'
    assert_includes html, "Phone: 555-1234"
    assert_includes html, 'data-testid="row-email"'
    assert_includes html, "Email: u@example.com"
  end

  test "renders without title when title is nil and no CTA" do
    html = render_component(::Decor::Daisy::PropertyList.new) do |list|
      list.with_section { "row".html_safe }
    end
    refute_includes html, "decor:justify-between"
  end
end
