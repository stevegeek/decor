# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::TagTest < ActiveSupport::TestCase
  test "renders label with whitespace-nowrap" do
    html = render_component(::Decor::Suite::Tag.new(label: "Beverages"))
    assert_includes html, "Beverages"
    assert_includes html, "decor:whitespace-nowrap"
  end

  test "default neutral palette uses muted base-200 / base-content" do
    html = render_component(::Decor::Suite::Tag.new(label: "x"))
    assert_includes html, "decor:bg-base-200"
    assert_includes html, "decor:text-base-content"
  end

  test "color :success switches to muted success palette" do
    html = render_component(::Decor::Suite::Tag.new(label: "ok", color: :success))
    assert_includes html, "decor:bg-success/10"
    assert_includes html, "decor:text-success"
    refute_includes html, "decor:bg-base-200"
  end

  test "style :outlined uses border-y border-r (no left border) on chosen color" do
    html = render_component(::Decor::Suite::Tag.new(label: "ok", color: :success, style: :outlined))
    assert_includes html, "decor:border-y"
    assert_includes html, "decor:border-r"
    assert_includes html, "decor:border-success/40"
    refute_includes html, "decor:border-l"
  end

  test "renders LED dot by default" do
    html = render_component(::Decor::Suite::Tag.new(label: "x", color: :success))
    assert_includes html, "decor:rounded-full"
    assert_includes html, "decor:bg-success"
  end

  test "led: false suppresses the LED dot span" do
    html = render_component(::Decor::Suite::Tag.new(label: "x", color: :success, led: false))
    # LED span carries rounded-full + shadow halo classes — neither should appear.
    refute_includes html, "decor:shadow-success/20"
  end

  test "icon: 'star' renders icon and not LED" do
    html = render_component(::Decor::Suite::Tag.new(label: "Featured", icon: "star", color: :warning))
    assert_includes html, "tabler-filled-star"
    refute_includes html, "decor:shadow-warning/20"
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
end
