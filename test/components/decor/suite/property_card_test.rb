# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::PropertyCardTest < ActiveSupport::TestCase
  test "renders title with suite-section-title typography" do
    html = render_component(::Decor::Suite::PropertyCard.new(title: "Order summary"))
    assert_includes html, "Order summary"
    assert_includes html, "decor:suite-section-title"
    assert_includes html, "decor:text-gray-900"
  end

  test "renders suite surface chrome with hairline border and rounded card corners" do
    html = render_component(::Decor::Suite::PropertyCard.new(title: "T"))
    assert_includes html, "decor:bg-white"
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:rounded-suite-card"
  end

  test "default accent is primary using suite-primary-500 left border" do
    html = render_component(::Decor::Suite::PropertyCard.new(title: "T"))
    assert_includes html, "decor:border-l-2"
    assert_includes html, "decor:border-l-suite-primary-500"
  end

  test "success accent uses suite-success-500 left border" do
    html = render_component(::Decor::Suite::PropertyCard.new(title: "T", accent: :success))
    assert_includes html, "decor:border-l-suite-success-500"
  end

  test "warning accent uses suite-warning-500 left border" do
    html = render_component(::Decor::Suite::PropertyCard.new(title: "T", accent: :warning))
    assert_includes html, "decor:border-l-suite-warning-500"
  end

  test "danger accent uses suite-danger-500 left border" do
    html = render_component(::Decor::Suite::PropertyCard.new(title: "T", accent: :danger))
    assert_includes html, "decor:border-l-suite-danger-500"
  end

  test "neutral accent uses gray-400 left border" do
    html = render_component(::Decor::Suite::PropertyCard.new(title: "T", accent: :neutral))
    assert_includes html, "decor:border-l-gray-400"
  end

  test "renders no body wrapper when no properties have been added" do
    html = render_component(::Decor::Suite::PropertyCard.new(title: "T"))
    refute_includes html, "decor:grid-cols-"
  end

  test "default layout is a 3-column grid" do
    html = render_component(::Decor::Suite::PropertyCard.new(title: "T")) do |card|
      card.with_property(label: "L", value: "V")
    end
    assert_includes html, "decor:grid-cols-3"
    assert_includes html, "decor:gap-y-3"
    assert_includes html, "decor:gap-x-6"
  end

  test "columns: 2 renders grid-cols-2" do
    html = render_component(::Decor::Suite::PropertyCard.new(title: "T", columns: 2)) do |card|
      card.with_property(label: "L", value: "V")
    end
    assert_includes html, "decor:grid-cols-2"
  end

  test "columns: 4 renders grid-cols-4" do
    html = render_component(::Decor::Suite::PropertyCard.new(title: "T", columns: 4)) do |card|
      card.with_property(label: "L", value: "V")
    end
    assert_includes html, "decor:grid-cols-4"
  end

  test "rows layout omits the body column grid wrapper and uses row-layout properties" do
    html = render_component(::Decor::Suite::PropertyCard.new(title: "T", layout: :rows)) do |card|
      card.with_property(label: "L", value: "V")
    end
    refute_includes html, "decor:grid-cols-2"
    refute_includes html, "decor:grid-cols-3"
    refute_includes html, "decor:grid-cols-4"
    assert_includes html, "decor:grid-cols-[10rem_1fr]"
  end

  test "grid layout properties use stack layout internally" do
    html = render_component(::Decor::Suite::PropertyCard.new(title: "T")) do |card|
      card.with_property(label: "Alpha", value: "AAA")
    end
    assert_includes html, "decor:suite-label"
    assert_includes html, "decor:suite-dense-body"
  end

  test "with_cta block renders trailing action in the title row" do
    html = render_component(::Decor::Suite::PropertyCard.new(title: "Header")) do |card|
      card.with_cta { '<button data-testid="cta">Edit</button>'.html_safe }
    end
    assert_includes html, 'data-testid="cta"'
    assert_includes html, "Edit"
    assert_includes html, "decor:shrink-0"
    cta_at = html.index('data-testid="cta"')
    title_at = html.index("Header")
    assert title_at && cta_at, "both title and cta rendered"
    assert title_at < cta_at, "title precedes cta in title row"
  end

  test "no cta is rendered when with_cta was not called" do
    html = render_component(::Decor::Suite::PropertyCard.new(title: "Header"))
    refute_includes html, "decor:shrink-0"
  end

  test "block-rendered property value is captured and emitted in place of value:" do
    html = render_component(::Decor::Suite::PropertyCard.new(title: "T")) do |card|
      card.with_property(label: "Status") do
        '<span data-testid="rich">Active</span>'.html_safe
      end
    end
    assert_includes html, "Status"
    assert_includes html, 'data-testid="rich"'
    assert_includes html, "Active"
  end

  test "meta caption renders alongside value" do
    html = render_component(::Decor::Suite::PropertyCard.new(title: "T")) do |card|
      card.with_property(label: "Tax", value: "$96.25", meta: "8.75%")
    end
    assert_includes html, "8.75%"
    assert_includes html, "decor:suite-description"
  end

  test "icon prop renders an icon alongside the label" do
    html = render_component(::Decor::Suite::PropertyCard.new(title: "T")) do |card|
      card.with_property(label: "Customer", value: "Acme", icon: "user")
    end
    assert_includes html, "Customer"
    assert_includes html, "Acme"
    assert_includes html, "<svg"
  end

  test "multiple properties render in insertion order" do
    html = render_component(::Decor::Suite::PropertyCard.new(title: "T")) do |card|
      card.with_property(label: "ALPHA", value: "A")
      card.with_property(label: "BETA", value: "B")
      card.with_property(label: "GAMMA", value: "C")
    end
    a = html.index("ALPHA")
    b = html.index("BETA")
    g = html.index("GAMMA")
    assert a && b && g, "all labels rendered"
    assert a < b, "alpha precedes beta"
    assert b < g, "beta precedes gamma"
  end

end
