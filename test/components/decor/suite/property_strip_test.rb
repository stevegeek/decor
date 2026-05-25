# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::PropertyStripTest < ActiveSupport::TestCase
  test "renders nothing-but-root when no properties added" do
    html = render_component(::Decor::Suite::PropertyStrip.new)
    refute_includes html, "decor:border-suite-hairline"
  end

  test "renders title with suite-section-title typography" do
    html = render_component(::Decor::Suite::PropertyStrip.new(title: "Order summary"))
    assert_includes html, "Order summary"
    assert_includes html, "decor:suite-section-title"
    assert_includes html, "decor:text-gray-900"
  end

  test "renders subtitle with suite-description typography" do
    html = render_component(::Decor::Suite::PropertyStrip.new(subtitle: "Key facts"))
    assert_includes html, "Key facts"
    assert_includes html, "decor:suite-description"
    assert_includes html, "decor:text-gray-500"
  end

  test "renders strip with hairline borders top and bottom when properties are present" do
    html = render_component(::Decor::Suite::PropertyStrip.new) do |strip|
      strip.with_property(label: "L", value: "V")
    end
    assert_includes html, "decor:border-y"
    assert_includes html, "decor:border-suite-hairline"
  end

  test "default min_column_width is 140 in the grid template" do
    html = render_component(::Decor::Suite::PropertyStrip.new) do |strip|
      strip.with_property(label: "L", value: "V")
    end
    assert_includes html, "minmax(140px, 1fr)"
  end

  test "custom min_column_width is applied to grid template" do
    html = render_component(::Decor::Suite::PropertyStrip.new(min_column_width: 200)) do |strip|
      strip.with_property(label: "L", value: "V")
    end
    assert_includes html, "minmax(200px, 1fr)"
  end

  test "plain value pair renders label with suite-label and value with suite-dense-body" do
    html = render_component(::Decor::Suite::PropertyStrip.new) do |strip|
      strip.with_property(label: "Order #", value: "PO-10042")
    end
    assert_includes html, "Order #"
    assert_includes html, "PO-10042"
    assert_includes html, "decor:suite-label"
    assert_includes html, "decor:suite-dense-body"
    assert_includes html, "decor:tabular-nums"
  end

  test "meta caption renders with suite-description" do
    html = render_component(::Decor::Suite::PropertyStrip.new) do |strip|
      strip.with_property(label: "Tax", value: "$96.25", meta: "8.75%")
    end
    assert_includes html, "8.75%"
    assert_includes html, "decor:suite-description"
  end

  test "icon prop renders the icon alongside the label" do
    html = render_component(::Decor::Suite::PropertyStrip.new) do |strip|
      strip.with_property(label: "Customer", value: "Acme", icon: "user")
    end
    assert_includes html, "Customer"
    assert_includes html, "Acme"
    assert_includes html, "<svg"
  end

  test "block-rendered property value is captured and emitted in place of value:" do
    html = render_component(::Decor::Suite::PropertyStrip.new) do |strip|
      strip.with_property(label: "Status") do
        '<span data-testid="rich-value">Active</span>'.html_safe
      end
    end
    assert_includes html, "Status"
    assert_includes html, 'data-testid="rich-value"'
    assert_includes html, "Active"
  end

  test "multiple properties render in insertion order" do
    html = render_component(::Decor::Suite::PropertyStrip.new) do |strip|
      strip.with_property(label: "ALPHA_LABEL", value: "AAA")
      strip.with_property(label: "BETA_LABEL", value: "BBB")
      strip.with_property(label: "GAMMA_LABEL", value: "CCC")
    end
    alpha_at = html.index("ALPHA_LABEL")
    beta_at = html.index("BETA_LABEL")
    gamma_at = html.index("GAMMA_LABEL")
    assert alpha_at && beta_at && gamma_at, "all property labels rendered"
    assert alpha_at < beta_at, "alpha precedes beta"
    assert beta_at < gamma_at, "beta precedes gamma"
  end
end
