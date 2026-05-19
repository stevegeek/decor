# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::PanelTest < ActiveSupport::TestCase
  test "root has suite surface chrome" do
    html = render_component(::Decor::Suite::Panel.new(title: "Settings")) { "body".html_safe }
    assert_includes html, "decor:bg-white"
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:rounded-suite-card"
    assert_includes html, "decor:overflow-hidden"
  end

  test "renders title in header row with suite-section-title token" do
    html = render_component(::Decor::Suite::Panel.new(title: "Settings")) { "body".html_safe }
    assert_includes html, "Settings"
    assert_includes html, "decor:suite-section-title"
    assert_includes html, "decor:text-gray-900"
  end

  test "header row has suite-hairline bottom border" do
    html = render_component(::Decor::Suite::Panel.new(title: "Settings")) { "body".html_safe }
    assert_includes html, "decor:border-b"
    assert_includes html, "decor:border-suite-hairline"
  end

  test "renders body content inside body wrapper with suite-description token" do
    html = render_component(::Decor::Suite::Panel.new(title: "Settings")) { "body-content".html_safe }
    assert_includes html, "body-content"
    assert_includes html, "decor:suite-description"
    assert_includes html, "decor:text-gray-500"
  end

  test "renders icon in header when icon prop supplied" do
    html = render_component(::Decor::Suite::Panel.new(title: "Settings", icon: "cog")) { "body".html_safe }
    # Icon component emits an svg with the gray-500 / sizing classes we asked for.
    assert_includes html, "decor:w-[18px]"
    assert_includes html, "decor:h-[18px]"
    assert_includes html, "decor:shrink-0"
  end

  test "icon-only (no title) still renders header row" do
    html = render_component(::Decor::Suite::Panel.new(title: "", icon: "cog")) { "body".html_safe }
    assert_includes html, "decor:border-b"
    assert_includes html, "decor:w-[18px]"
  end

  test "omits header row entirely when both title and icon are blank" do
    html = render_component(::Decor::Suite::Panel.new(title: "")) { "body".html_safe }
    refute_includes html, "decor:suite-section-title"
    # Without header chrome, the only border-b would be inside it.
    refute_includes html, "decor:border-b"
  end

  test "title and body appear in document order" do
    html = render_component(::Decor::Suite::Panel.new(title: "TITLE_SLOT")) { "BODY_SLOT".html_safe }
    title_at = html.index("TITLE_SLOT")
    body_at = html.index("BODY_SLOT")
    assert title_at, "title missing"
    assert body_at, "body missing"
    assert title_at < body_at, "title should precede body"
  end

  test "title rendered as h3" do
    html = render_component(::Decor::Suite::Panel.new(title: "Section")) { "body".html_safe }
    assert_match(/<h3[^>]*>\s*Section\s*<\/h3>/, html)
  end

  test "inherits from abstract Components::Panel" do
    assert ::Decor::Suite::Panel < ::Decor::Components::Panel
  end

  test "every tailwind utility on the root carries the decor: prefix" do
    html = render_component(::Decor::Suite::Panel.new(title: "x")) { "y".html_safe }
    root_class = html[/class="([^"]*)"/, 1]
    assert root_class, "no class attribute found on root"
    # The framework injects a BEM-style component selector (decor--suite--panel)
    # which is intentionally NOT a Tailwind utility and is not prefixed.
    tailwind_utilities = root_class.split.reject { |c| c.start_with?("decor--") }
    refute_empty tailwind_utilities, "expected tailwind utilities on root"
    tailwind_utilities.each do |cls|
      assert cls.start_with?("decor:"), "non-prefixed tailwind utility on root: #{cls}"
    end
  end
end
