# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::PanelGroupTest < ActiveSupport::TestCase
  test "renders root surface chrome with suite tokens" do
    html = render_component(::Decor::Suite::PanelGroup.new(title: "Group"))
    assert_includes html, "decor:bg-white"
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:rounded-suite-card"
  end

  test "renders title with suite-section-title typography" do
    html = render_component(::Decor::Suite::PanelGroup.new(title: "Dashboard"))
    assert_includes html, "Dashboard"
    assert_includes html, "decor:suite-section-title"
    assert_includes html, "decor:text-gray-900"
  end

  test "renders description with suite-description typography" do
    html = render_component(::Decor::Suite::PanelGroup.new(
      title: "Stats",
      description: "Some helpful copy"
    ))
    assert_includes html, "Some helpful copy"
    assert_includes html, "decor:suite-description"
    assert_includes html, "decor:text-gray-500"
  end

  test "omits header chrome entirely when title/description/cta all absent" do
    html = render_component(::Decor::Suite::PanelGroup.new(title: "")) do |group|
      group.with_panel_row { group.plain("only-row") }
    end
    assert_includes html, "only-row"
    refute_includes html, "decor:suite-section-title"
  end

  test "header row separates from body with suite-hairline border" do
    html = render_component(::Decor::Suite::PanelGroup.new(title: "X"))
    assert_includes html, "decor:border-b"
    assert_includes html, "decor:border-suite-hairline"
  end

  test "cta slot renders right-aligned next to title" do
    html = render_component(::Decor::Suite::PanelGroup.new(title: "With CTA")) do |group|
      group.cta { '<button data-testid="cta">Refresh</button>'.html_safe }
    end
    assert_includes html, 'data-testid="cta"'
    assert_includes html, "decor:justify-between"
    assert_includes html, "decor:shrink-0"
  end

  test "first panel row has no top divider, subsequent rows do" do
    html = render_component(::Decor::Suite::PanelGroup.new(title: "Group")) do |group|
      group.with_panel_row { group.render(::Decor::Suite::Panel.new(title: "P1")) { "r1-body".html_safe } }
      group.with_panel_row { group.render(::Decor::Suite::Panel.new(title: "P2")) { "r2-body".html_safe } }
    end
    r1_at = html.index("r1-body")
    r2_at = html.index("r2-body")
    assert r1_at && r2_at
    assert r1_at < r2_at, "rows should render in order"
    assert_includes html, "decor:border-t"
  end

  test "panel rows use flex-wrap with suite-section-gap" do
    html = render_component(::Decor::Suite::PanelGroup.new(title: "Group")) do |group|
      group.with_panel_row { group.render(::Decor::Suite::Panel.new(title: "P")) { "x".html_safe } }
    end
    assert_includes html, "decor:flex"
    assert_includes html, "decor:flex-wrap"
    assert_includes html, "decor:suite-section-gap"
  end

  test "renders nested Suite::Panel children inside a row" do
    html = render_component(::Decor::Suite::PanelGroup.new(title: "Group")) do |group|
      group.with_panel_row do
        group.render(::Decor::Suite::Panel.new(title: "Inner Panel")) { "inner-body".html_safe }
      end
    end
    assert_includes html, "Inner Panel"
    assert_includes html, "inner-body"
  end

  test "trailing block content renders after panel rows" do
    html = render_component(::Decor::Suite::PanelGroup.new(title: "Group")) do |group|
      group.with_panel_row { group.render(::Decor::Suite::Panel.new(title: "P")) { "row-content".html_safe } }
      "trailing-content".html_safe
    end
    row_at = html.index("row-content")
    trailing_at = html.index("trailing-content")
    assert row_at && trailing_at, "both row and trailing content must render"
    assert row_at < trailing_at, "trailing content should render after rows"
  end

  test "renders multiple panel rows in declaration order" do
    html = render_component(::Decor::Suite::PanelGroup.new(title: "Group")) do |group|
      group.with_panel_row { group.render(::Decor::Suite::Panel.new(title: "PA")) { "a-body".html_safe } }
      group.with_panel_row { group.render(::Decor::Suite::Panel.new(title: "PB")) { "b-body".html_safe } }
      group.with_panel_row { group.render(::Decor::Suite::Panel.new(title: "PC")) { "c-body".html_safe } }
    end
    a_at = html.index("a-body")
    b_at = html.index("b-body")
    c_at = html.index("c-body")
    assert a_at && b_at && c_at
    assert a_at < b_at
    assert b_at < c_at
  end

  test "inherits from PhlexComponent through abstract base" do
    component = ::Decor::Suite::PanelGroup.new(title: "X")
    assert_kind_of ::Decor::PhlexComponent, component
    assert_kind_of ::Decor::Components::PanelGroup, component
  end

  test "all generated tailwind utility classes are decor:-prefixed" do
    html = render_component(::Decor::Suite::PanelGroup.new(title: "Group", description: "d")) do |group|
      group.cta { "cta".html_safe }
      group.with_panel_row { group.render(::Decor::Suite::Panel.new(title: "P")) { "x".html_safe } }
    end
    classes = html.scan(/class="([^"]+)"/).flatten.flat_map { |c| c.split(/\s+/) }.reject(&:empty?)
    refute_empty classes
    bare = classes.reject { |c| c.start_with?("decor:", "decor--") }
    assert_empty bare, "Found non-prefixed Tailwind classes: #{bare.inspect}"
  end
end
