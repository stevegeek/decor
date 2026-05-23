# frozen_string_literal: true

require "test_helper"

class ::Decor::Daisy::PropertyCardTest < ActiveSupport::TestCase
  test "renders root with daisy property-card identifier" do
    html = render_component(::Decor::Daisy::PropertyCard.new(title: "T"))
    assert_includes html, "decor--daisy--property-card"
  end

  test "renders title with daisy h3 typography" do
    html = render_component(::Decor::Daisy::PropertyCard.new(title: "Order summary"))
    assert_includes html, "Order summary"
    assert_includes html, "<h3"
    assert_includes html, "decor:font-semibold"
  end

  test "renders surface chrome with base-100 fill and rounded-box" do
    html = render_component(::Decor::Daisy::PropertyCard.new(title: "T"))
    assert_includes html, "decor:bg-base-100"
    assert_includes html, "decor:border-base-300"
    assert_includes html, "decor:rounded-box"
  end

  test "default accent is primary using border-l-primary" do
    html = render_component(::Decor::Daisy::PropertyCard.new(title: "T"))
    assert_includes html, "decor:border-l-2"
    assert_includes html, "decor:border-l-primary"
  end

  test "success accent uses border-l-success" do
    html = render_component(::Decor::Daisy::PropertyCard.new(title: "T", accent: :success))
    assert_includes html, "decor:border-l-success"
  end

  test "warning accent uses border-l-warning" do
    html = render_component(::Decor::Daisy::PropertyCard.new(title: "T", accent: :warning))
    assert_includes html, "decor:border-l-warning"
  end

  test "danger accent uses border-l-error" do
    html = render_component(::Decor::Daisy::PropertyCard.new(title: "T", accent: :danger))
    assert_includes html, "decor:border-l-error"
  end

  test "neutral accent uses border-l-base-300" do
    html = render_component(::Decor::Daisy::PropertyCard.new(title: "T", accent: :neutral))
    assert_includes html, "decor:border-l-base-300"
  end

  test "renders no body wrapper when no properties have been added" do
    html = render_component(::Decor::Daisy::PropertyCard.new(title: "T"))
    refute_includes html, "decor:grid-cols-"
  end

  test "default layout is a 3-column grid" do
    html = render_component(::Decor::Daisy::PropertyCard.new(title: "T")) do |card|
      card.with_property(label: "L", value: "V")
    end
    assert_includes html, "decor:grid-cols-3"
    assert_includes html, "decor:gap-y-3"
    assert_includes html, "decor:gap-x-6"
  end

  test "columns: 2 renders grid-cols-2" do
    html = render_component(::Decor::Daisy::PropertyCard.new(title: "T", columns: 2)) do |card|
      card.with_property(label: "L", value: "V")
    end
    assert_includes html, "decor:grid-cols-2"
  end

  test "columns: 4 renders grid-cols-4" do
    html = render_component(::Decor::Daisy::PropertyCard.new(title: "T", columns: 4)) do |card|
      card.with_property(label: "L", value: "V")
    end
    assert_includes html, "decor:grid-cols-4"
  end

  test "rows layout omits the body column grid wrapper and uses row-layout properties" do
    html = render_component(::Decor::Daisy::PropertyCard.new(title: "T", layout: :rows)) do |card|
      card.with_property(label: "L", value: "V")
    end
    refute_includes html, "decor:grid-cols-2"
    refute_includes html, "decor:grid-cols-3"
    refute_includes html, "decor:grid-cols-4"
    assert_includes html, "decor:grid-cols-[10rem_1fr]"
  end

  test "with_cta block renders trailing action in the title row" do
    html = render_component(::Decor::Daisy::PropertyCard.new(title: "Header")) do |card|
      card.with_cta { '<button data-testid="cta">Edit</button>'.html_safe }
    end
    assert_includes html, 'data-testid="cta"'
    assert_includes html, "Edit"
    assert_includes html, "decor:shrink-0"
  end

  test "no cta is rendered when with_cta was not called" do
    html = render_component(::Decor::Daisy::PropertyCard.new(title: "Header"))
    refute_includes html, "decor:shrink-0"
  end

  test "block-rendered property value is captured and emitted in place of value:" do
    html = render_component(::Decor::Daisy::PropertyCard.new(title: "T")) do |card|
      card.with_property(label: "Status") do
        '<span data-testid="rich">Active</span>'.html_safe
      end
    end
    assert_includes html, "Status"
    assert_includes html, 'data-testid="rich"'
    assert_includes html, "Active"
  end

  test "multiple properties render in insertion order" do
    html = render_component(::Decor::Daisy::PropertyCard.new(title: "T")) do |card|
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
