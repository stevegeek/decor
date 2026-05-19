# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::PageTest < ActiveSupport::TestCase
  test "renders successfully with default attributes and Suite root class" do
    html = render_component(::Decor::Suite::Page.new)
    assert_includes html, "decor--suite--page"
    assert_includes html, "decor:w-full"
    refute_includes html, "decor:min-h-screen"
  end

  test "supports body content via yield" do
    html = render_component(::Decor::Suite::Page.new) { "<div>Page content here</div>".html_safe }
    assert_includes html, "Page content here"
  end

  test "applies full-height utility when enabled" do
    html = render_component(::Decor::Suite::Page.new(full_height: true))
    assert_includes html, "decor:min-h-screen"
  end

  test "supports header slot" do
    component = ::Decor::Suite::Page.new
    component.with_header { "<header>Page Header</header>".html_safe }
    html = render_component(component)
    assert_includes html, "Page Header"
  end

  test "supports hero slot rendered before header and content" do
    component = ::Decor::Suite::Page.new
    component.with_hero { "Hero".html_safe }
    component.with_header { "Header".html_safe }
    html = render_component(component) { "Content".html_safe }

    assert html.index("Hero") < html.index("Header")
    assert html.index("Header") < html.index("Content")
  end

  test "supports tabs slot wrapped in a suite-hairline divider" do
    component = ::Decor::Suite::Page.new
    component.with_tabs { "<div>Tab content</div>".html_safe }
    html = render_component(component)

    assert_includes html, "Tab content"
    assert_includes html, "decor:border-suite-hairline"
  end

  test "renders Suite Flash by default" do
    html = render_component(::Decor::Suite::Page.new)
    assert_includes html, "decor--suite--flash"
  end

  test "omits Flash when include_flash: false" do
    html = render_component(::Decor::Suite::Page.new(include_flash: false))
    refute_includes html, "decor--suite--flash"
    refute_includes html, "decor--daisy--flash"
  end

  test "padding :lg uses suite py-10 rhythm (not Daisy py-12)" do
    html = render_component(::Decor::Suite::Page.new(padding: :lg))
    assert_includes html, "decor:py-10"
    refute_includes html, "decor:py-12"
  end

  test "spacing :md uses suite space-y-6 rhythm (not Daisy space-y-8)" do
    html = render_component(::Decor::Suite::Page.new(spacing: :md))
    assert_includes html, "decor:space-y-6"
  end

  test "background :hero uses suite-gray-25 muted token (not Daisy bg-base-200)" do
    html = render_component(::Decor::Suite::Page.new(background: :hero))
    assert_includes html, "decor:bg-suite-gray-25"
    refute_includes html, "decor:bg-base-200"
  end

  test "background :primary uses suite-primary-50 (not Daisy bg-primary/10)" do
    html = render_component(::Decor::Suite::Page.new(background: :primary))
    assert_includes html, "decor:bg-suite-primary-50"
    refute_includes html, "decor:bg-primary/10"
  end

  test "hero on tinted background wears rounded-suite-card chrome" do
    component = ::Decor::Suite::Page.new(background: :hero)
    component.with_hero { "Hero body".html_safe }
    html = render_component(component)

    assert_includes html, "Hero body"
    assert_includes html, "decor:rounded-suite-card"
    assert_includes html, "decor:border-suite-hairline"
  end

  test "inherits from Components::Page abstract base" do
    component = ::Decor::Suite::Page.new
    assert component.is_a?(::Decor::Components::Page)
    assert component.is_a?(::Decor::PhlexComponent)
  end

  test "default prop values match Components::Page defaults" do
    component = ::Decor::Suite::Page.new
    assert_equal :default, component.instance_variable_get(:@background)
    assert_equal :md, component.instance_variable_get(:@padding)
    assert_equal :md, component.instance_variable_get(:@spacing)
    assert_equal true, component.instance_variable_get(:@include_flash)
    assert_equal false, component.instance_variable_get(:@full_height)
  end
end
