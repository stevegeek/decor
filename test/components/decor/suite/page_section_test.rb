# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::PageSectionTest < ActiveSupport::TestCase
  test "root carries suite card chrome (white surface, hairline border, rounded-suite-card)" do
    html = render_component(::Decor::Suite::PageSection.new(title: "T"))
    assert_includes html, "decor:bg-white"
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:rounded-suite-card"
  end

  test "renders title with suite-section-title typography on gray-900 inside an h3" do
    html = render_component(::Decor::Suite::PageSection.new(title: "Section Title"))
    assert_includes html, "Section Title"
    assert_includes html, "<h3"
    assert_includes html, "decor:suite-section-title"
    assert_includes html, "decor:text-gray-900"
  end

  test "renders description with suite-description typography on gray-500" do
    html = render_component(::Decor::Suite::PageSection.new(description: "helper text"))
    assert_includes html, "helper text"
    assert_includes html, "decor:suite-description"
    assert_includes html, "decor:text-gray-500"
  end

  test "header strip uses suite-section-pad" do
    html = render_component(::Decor::Suite::PageSection.new(title: "T"))
    assert_includes html, "decor:suite-section-pad"
  end

  test "body block is wrapped with suite-section-pad padding by default" do
    html = render_component(::Decor::Suite::PageSection.new(title: "T")) { "body-content".html_safe }
    assert_includes html, "body-content"
    assert_operator html.scan("decor:suite-section-pad").size, :>=, 2
  end

  test "padding :none drops the body padding utility" do
    html = render_component(::Decor::Suite::PageSection.new(title: "T", padding: :none)) { "x".html_safe }
    assert_equal 1, html.scan("decor:suite-section-pad").size
  end

  test "separator: true with header content renders suite-hairline rule above body" do
    html = render_component(::Decor::Suite::PageSection.new(title: "T", separator: true)) { "body".html_safe }
    assert_includes html, "decor:border-t"
    assert_includes html, "decor:border-suite-hairline"
  end

  test "separator: false (default) does not render border-t between header and body" do
    html = render_component(::Decor::Suite::PageSection.new(title: "T")) { "body".html_safe }
    refute_includes html, "decor:border-t"
  end

  test "separator: true with NO header content does not render the rule (nothing to separate)" do
    html = render_component(::Decor::Suite::PageSection.new(separator: true)) { "body".html_safe }
    refute_includes html, "decor:border-t"
  end

  test "hero slot content renders above the header" do
    component = ::Decor::Suite::PageSection.new(title: "header-title")
    component.with_hero { "hero-slot-content".html_safe }
    html = render_component(component)
    hero_at = html.index("hero-slot-content")
    title_at = html.index("header-title")
    assert hero_at, "hero missing"
    assert title_at, "title missing"
    assert hero_at < title_at, "hero should render before header title"
  end

  test "cta slot renders inside an actions cluster with shrink-0 / gap-2" do
    component = ::Decor::Suite::PageSection.new(title: "T")
    component.with_cta { "cta-content".html_safe }
    html = render_component(component)
    assert_includes html, "cta-content"
    assert_includes html, "decor:shrink-0"
    assert_includes html, "decor:gap-2"
  end

  test "tag chips render via Suite::Tag (suite palette, not daisy)" do
    component = ::Decor::Suite::PageSection.new(title: "T")
    component.with_tag(label: "Beta", color: :success)
    html = render_component(component)
    assert_includes html, "Beta"
    assert_includes html, "decor:bg-suite-success-50"
    assert_includes html, "decor:text-suite-success-700"
  end

  test "background :primary swaps the surface fill to suite-primary-50" do
    html = render_component(::Decor::Suite::PageSection.new(background: :primary))
    assert_includes html, "decor:bg-suite-primary-50"
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:rounded-suite-card"
  end

  test "background :default leaves the card on the white surface" do
    html = render_component(::Decor::Suite::PageSection.new)
    assert_includes html, "decor:bg-white"
    refute_includes html, "decor:bg-suite-primary-50"
  end

  test "size :lg uses a larger body content gap than :sm" do
    html_sm = render_component(::Decor::Suite::PageSection.new(title: "T", size: :sm)) { "x".html_safe }
    html_lg = render_component(::Decor::Suite::PageSection.new(title: "T", size: :lg)) { "x".html_safe }
    assert_includes html_sm, "decor:gap-4"
    assert_includes html_lg, "decor:gap-6"
  end

  test "default size :md uses density-aware suite-section-gap on the body" do
    html = render_component(::Decor::Suite::PageSection.new(title: "T")) { "x".html_safe }
    assert_includes html, "decor:suite-section-gap"
  end

end
