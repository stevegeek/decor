# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::TagTest < ActiveSupport::TestCase
  test "renders label with whitespace-nowrap" do
    html = render_component(::Decor::Suite::Tag.new(label: "Beverages"))
    assert_includes html, "Beverages"
    assert_includes html, "decor:whitespace-nowrap"
  end

  test "default neutral palette uses muted gray-100 / gray-700" do
    html = render_component(::Decor::Suite::Tag.new(label: "x"))
    assert_includes html, "decor:bg-gray-100"
    assert_includes html, "decor:text-gray-700"
  end

  test "color :success switches to suite success-50 / success-700 palette" do
    html = render_component(::Decor::Suite::Tag.new(label: "ok", color: :success))
    assert_includes html, "decor:bg-suite-success-50"
    assert_includes html, "decor:text-suite-success-700"
    refute_includes html, "decor:bg-gray-100"
  end

  test "style :outlined uses border-y border-r (no left border) on chosen color" do
    html = render_component(::Decor::Suite::Tag.new(label: "ok", color: :success, style: :outlined))
    assert_includes html, "decor:border-y"
    assert_includes html, "decor:border-r"
    assert_includes html, "decor:border-suite-success-100"
    refute_includes html, "decor:border-l"
  end

  test "renders LED dot by default with suite-500 saturated bg and halo" do
    html = render_component(::Decor::Suite::Tag.new(label: "x", color: :success))
    assert_includes html, "decor:rounded-full"
    assert_includes html, "decor:bg-suite-success-500"
    assert_includes html, "decor:shadow-suite-success-500/20"
  end

  test "led: false suppresses the LED dot halo" do
    html = render_component(::Decor::Suite::Tag.new(label: "x", color: :success, led: false))
    refute_includes html, "decor:shadow-suite-success-500/20"
  end

  test "icon: 'star' renders icon and not LED" do
    html = render_component(::Decor::Suite::Tag.new(label: "Featured", icon: "star", color: :warning))
    assert_includes html, "tabler-filled-star"
    refute_includes html, "decor:shadow-suite-warning-500/20"
  end

  test "nose ::before clip-path classes present on standard variant" do
    html = render_component(::Decor::Suite::Tag.new(label: "x"))
    assert_includes html, "decor:before:[clip-path:polygon(0_50%,100%_0,100%_100%)]"
    assert_includes html, "decor:before:bg-inherit"
  end

  test "removable: true renders close button with passed data-action and drops nose chrome" do
    html = render_component(
      ::Decor::Suite::Tag.new(
        label: "Beverages",
        removable: true,
        remove_options: {data: {action: "click->cart#remove"}}
      )
    )
    assert_includes html, "data-action"
    assert_includes html, "click->cart#remove"
    assert_includes html, "tabler-x"
    refute_includes html, "before:[clip-path"
  end

  test "removable variant uses suite primary chrome" do
    html = render_component(::Decor::Suite::Tag.new(label: "x", removable: true))
    assert_includes html, "decor:bg-suite-primary-50"
    assert_includes html, "decor:border-suite-primary-200"
    assert_includes html, "decor:text-suite-primary-800"
  end

  test "default size :sm uses suite-description typography (matches Confinus :small)" do
    html = render_component(::Decor::Suite::Tag.new(label: "x"))
    assert_includes html, "decor:suite-description"
    # Sm-sized padding/margin landmarks.
    assert_includes html, "decor:px-[9px]"
    assert_includes html, "decor:ml-[11px]"
  end

  test "body uses rounded-r-suite-control radius" do
    html = render_component(::Decor::Suite::Tag.new(label: "x"))
    assert_includes html, "decor:rounded-r-suite-control"
  end
end
