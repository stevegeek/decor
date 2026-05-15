# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::TooltipTest < ActiveSupport::TestCase
  test "renders anchor + hidden tip bubble by default" do
    html = render_component(::Decor::Suite::Tooltip.new(tip_text: "Help")) { "Hover me" }
    assert_includes html, "Hover me"
    assert_includes html, "Help"
    # Bubble starts hidden — controller toggles visibility on hover/click.
    assert_includes html, "decor:hidden"
  end

  test "uses dark gray-900 bubble with white text and suite-control radius" do
    html = render_component(::Decor::Suite::Tooltip.new(tip_text: "x")) { "anchor" }
    assert_includes html, "decor:bg-gray-900"
    assert_includes html, "decor:text-white"
    assert_includes html, "decor:rounded-suite-control"
  end

  test "uses suite-description typography token" do
    html = render_component(::Decor::Suite::Tooltip.new(tip_text: "x")) { "anchor" }
    assert_includes html, "decor:suite-description"
  end

  test "uses suite-fast motion duration" do
    html = render_component(::Decor::Suite::Tooltip.new(tip_text: "x")) { "anchor" }
    assert_includes html, "decor:duration-suite-fast"
  end

  test "emits Suite stimulus controller and mouseover/mouseout/click actions" do
    html = render_component(::Decor::Suite::Tooltip.new(tip_text: "x")) { "anchor" }
    assert_includes html, "decor--suite--tooltip"
    assert_includes html, "mouseover"
    assert_includes html, "mouseout"
    assert_includes html, "click"
  end

  test "exposes placement and offset as stimulus values" do
    html = render_component(::Decor::Suite::Tooltip.new(tip_text: "x", position: :bottom, offset: 12)) { "anchor" }
    assert_includes html, "placement-value"
    assert_includes html, "bottom"
    assert_includes html, "offset-value"
    assert_includes html, "12"
  end

  test "accepts -start / -end placement variants" do
    html = render_component(::Decor::Suite::Tooltip.new(tip_text: "x", position: :"top-start")) { "anchor" }
    assert_includes html, "top-start"
  end

  test "accepts all four cardinal placements without raising" do
    [:top, :bottom, :left, :right].each do |pos|
      html = render_component(::Decor::Suite::Tooltip.new(tip_text: "x", position: pos)) { "a" }
      assert_includes html, pos.to_s
    end
  end

  test "renders arrow span by default" do
    html = render_component(::Decor::Suite::Tooltip.new(tip_text: "x")) { "anchor" }
    assert_includes html, "decor:rotate-45"
    assert_includes html, "target=\"arrow\""
  end

  test "omits arrow span when arrow: false" do
    html = render_component(::Decor::Suite::Tooltip.new(tip_text: "x", arrow: false)) { "anchor" }
    refute_includes html, "decor:rotate-45"
  end

  test "renders block-based tip content via with_tip_content" do
    component = ::Decor::Suite::Tooltip.new
    component.with_tip_content { "Block tip body" }
    html = render_component(component) { "anchor" }
    assert_includes html, "Block tip body"
    assert_includes html, "anchor"
  end

  test "root uses inline-block + relative positioning so anchor wraps inline" do
    html = render_component(::Decor::Suite::Tooltip.new(tip_text: "x")) { "anchor" }
    assert_includes html, "decor:inline-block"
    assert_includes html, "decor:relative"
  end

  test "bubble target is absolute z-50 w-max for floating-element layout" do
    html = render_component(::Decor::Suite::Tooltip.new(tip_text: "x")) { "anchor" }
    assert_includes html, "decor:absolute"
    assert_includes html, "decor:z-50"
    assert_includes html, "decor:w-max"
  end

  test "no daisyUI semantic color leakage" do
    html = render_component(::Decor::Suite::Tooltip.new(tip_text: "x")) { "anchor" }
    refute_includes html, "decor:d-tooltip"
    refute_includes html, "decor:bg-info"
    refute_includes html, "decor:bg-primary"
    refute_includes html, "data-tip"
  end

  test "inherits from abstract Decor::Components::Tooltip" do
    assert_operator ::Decor::Suite::Tooltip, :<, ::Decor::Components::Tooltip
  end
end
