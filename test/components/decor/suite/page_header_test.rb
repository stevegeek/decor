# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::PageHeaderTest < ActiveSupport::TestCase
  test "renders title with suite-section-title token and h1 by default" do
    html = render_component(::Decor::Suite::PageHeader.new(title: "Orders"))
    assert_includes html, "Orders"
    assert_includes html, "decor:suite-section-title"
    assert_includes html, "<h1"
  end

  test "renders subtitle with suite-description token" do
    html = render_component(::Decor::Suite::PageHeader.new(title: "T", subtitle: "Manage everything"))
    assert_includes html, "Manage everything"
    assert_includes html, "decor:suite-description"
  end

  test "renders description with suite-description token" do
    html = render_component(::Decor::Suite::PageHeader.new(title: "T", description: "Long-form description body."))
    assert_includes html, "Long-form description body."
    assert_includes html, "decor:suite-description"
  end

  test "default background is white and border hairline applied" do
    html = render_component(::Decor::Suite::PageHeader.new(title: "T"))
    assert_includes html, "decor:bg-white"
    assert_includes html, "decor:border-b"
    assert_includes html, "decor:border-suite-hairline"
  end

  test "background :hero swaps to suite-gray-25 surface (no gradient)" do
    html = render_component(::Decor::Suite::PageHeader.new(title: "T", background: :hero))
    assert_includes html, "decor:bg-suite-gray-25"
    refute_includes html, "decor:bg-gradient"
  end

  test "background :transparent omits any decor:bg-* class" do
    html = render_component(::Decor::Suite::PageHeader.new(title: "T", background: :transparent))
    refute_includes html, "decor:bg-white"
    refute_includes html, "decor:bg-suite-gray-25"
  end

  test "border: false drops the hairline divider" do
    html = render_component(::Decor::Suite::PageHeader.new(title: "T", border: false))
    refute_includes html, "decor:border-suite-hairline"
  end

  test "default padding uses suite-section-pad token" do
    html = render_component(::Decor::Suite::PageHeader.new(title: "T"))
    assert_includes html, "decor:suite-section-pad"
  end

  test "renders actions slot content" do
    component = ::Decor::Suite::PageHeader.new(title: "T")
    component.with_actions { "Edit Delete" }
    html = render_component(component)
    assert_includes html, "Edit Delete"
  end

  test "renders cta slot content" do
    component = ::Decor::Suite::PageHeader.new(title: "T")
    component.with_cta { "Primary CTA" }
    html = render_component(component)
    assert_includes html, "Primary CTA"
  end

  test "renders breadcrumbs slot with suite-description above the header body" do
    component = ::Decor::Suite::PageHeader.new(title: "T")
    component.with_breadcrumbs { "Home > Orders" }
    html = render_component(component)
    assert_includes html, "Home &gt; Orders"
    assert_includes html, "decor:suite-description"
  end

  test "centered layout uses text-center and centered max-width" do
    html = render_component(::Decor::Suite::PageHeader.new(title: "T", layout: :centered))
    assert_includes html, "decor:text-center"
    assert_includes html, "decor:max-w-3xl"
    assert_includes html, "decor:mx-auto"
  end

  test "compact layout suppresses description but keeps title" do
    html = render_component(::Decor::Suite::PageHeader.new(
      title: "Tight",
      layout: :compact,
      description: "Should not render in compact"
    ))
    assert_includes html, "Tight"
    refute_includes html, "Should not render in compact"
  end

  test "page_like layout downgrades title to h3" do
    html = render_component(::Decor::Suite::PageHeader.new(title: "Section", layout: :page_like))
    assert_includes html, "<h3"
    assert_includes html, "Section"
  end

  test "all base layout values render without raising" do
    [:default, :centered, :minimal, :hero, :compact, :page_like].each do |layout|
      component = ::Decor::Suite::PageHeader.new(title: "T", layout: layout)
      assert_nothing_raised { render_component(component) }
    end
  end

  test "inherits from the abstract Components::PageHeader base" do
    component = ::Decor::Suite::PageHeader.new(title: "T")
    assert_kind_of ::Decor::Components::PageHeader, component
  end
end
