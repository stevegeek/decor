# frozen_string_literal: true

require "test_helper"

class Decor::Suite::MapTest < ActiveSupport::TestCase
  def center
    ::Decor::Suite::Map::MapPoint.new(
      lat: 37.7749,
      lng: -122.4194,
      name: "SF",
      description: "City"
    )
  end

  def new_map(**overrides)
    ::Decor::Suite::Map.new(
      center: center,
      api_key: "test-key",
      **overrides
    )
  end

  test "renders root with suite card radius and hairline border by default" do
    rendered = render_component(new_map)
    assert_includes rendered, "decor:rounded-suite-card"
    assert_includes rendered, "decor:border-suite-hairline"
    assert_includes rendered, "decor:overflow-hidden"
  end

  test "renders inner map container with suite gray-25 surface" do
    rendered = render_component(new_map)
    assert_includes rendered, "decor:bg-suite-gray-25"
    assert_includes rendered, "decor:w-full"
    assert_includes rendered, "decor:h-full"
  end

  test "default md size renders h-96" do
    rendered = render_component(new_map)
    assert_includes rendered, "decor:h-96"
  end

  test "size :xs renders h-48" do
    rendered = render_component(new_map(size: :xs))
    assert_includes rendered, "decor:h-48"
  end

  test "size :sm renders h-64" do
    rendered = render_component(new_map(size: :sm))
    assert_includes rendered, "decor:h-64"
  end

  test "size :lg renders h-[28rem]" do
    rendered = render_component(new_map(size: :lg))
    assert_includes rendered, "decor:h-[28rem]"
  end

  test "size :xl renders h-[32rem]" do
    rendered = render_component(new_map(size: :xl))
    assert_includes rendered, "decor:h-[32rem]"
  end

  test "size :full renders h-full" do
    rendered = render_component(new_map(size: :full))
    assert_includes rendered, "decor:h-full"
  end

  test "full_width true renders w-full root" do
    rendered = render_component(new_map(full_width: true))
    assert_includes rendered, "decor:w-full"
  end

  test "full_width false renders w-96 root" do
    rendered = render_component(new_map(full_width: false))
    assert_includes rendered, "decor:w-96"
  end

  test "color :primary swaps border to suite-primary-200" do
    rendered = render_component(new_map(color: :primary))
    assert_includes rendered, "decor:border-suite-primary-200"
    refute_includes rendered, "decor:border-suite-hairline\""
  end

  test "color :success swaps border to suite-success-100" do
    rendered = render_component(new_map(color: :success))
    assert_includes rendered, "decor:border-suite-success-100"
  end

  test "color :warning swaps border to suite-warning-100" do
    rendered = render_component(new_map(color: :warning))
    assert_includes rendered, "decor:border-suite-warning-100"
  end

  test "color :error swaps border to suite-danger-100" do
    rendered = render_component(new_map(color: :error))
    assert_includes rendered, "decor:border-suite-danger-100"
  end

  test "color :info aliases to suite-primary-200" do
    rendered = render_component(new_map(color: :info))
    assert_includes rendered, "decor:border-suite-primary-200"
  end

  test "does not emit daisyUI semantic color borders" do
    rendered = render_component(new_map(color: :primary))
    refute_includes rendered, "decor:border-primary "
    refute_includes rendered, "decor:border-info "
  end

  test "disabled state adds opacity + non-interactive classes" do
    rendered = render_component(new_map(disabled: true))
    assert_includes rendered, "decor:opacity-50"
    assert_includes rendered, "decor:cursor-not-allowed"
    assert_includes rendered, "decor:pointer-events-none"
  end

  test "wires stimulus controller for suite map" do
    rendered = render_component(new_map)
    assert_includes rendered, "decor--suite--map"
  end

  test "exposes map_container stimulus target" do
    rendered = render_component(new_map)
    assert_includes rendered, "decor--suite--map-target=\"mapContainer\""
  end

  test "carries api_key as stimulus value" do
    rendered = render_component(new_map(api_key: "abc123"))
    assert_includes rendered, "api-key-value=\"abc123\""
  end

  test "carries zoom as stimulus value" do
    rendered = render_component(new_map(zoom: 15))
    assert_includes rendered, "zoom-value=\"15\""
  end

  test "carries center as JSON stimulus value" do
    rendered = render_component(new_map)
    assert_includes rendered, "center-value="
    assert_includes rendered, "37.7749"
    assert_includes rendered, "-122.4194"
  end

  test "carries points as JSON stimulus value" do
    point = ::Decor::Suite::Map::MapPoint.new(
      lat: 40.7128,
      lng: -74.0060,
      name: "NYC",
      description: "Big Apple"
    )
    rendered = render_component(new_map(points: [point]))
    assert_includes rendered, "points-value="
    assert_includes rendered, "40.7128"
  end

  test "carries map_type as stimulus value" do
    rendered = render_component(new_map(map_type: :satellite))
    assert_includes rendered, "map-type-value=\"satellite\""
  end

  test "carries interactive and show_controls as stimulus values" do
    rendered = render_component(new_map(interactive: false, show_controls: false))
    assert_includes rendered, "interactive-value=\"false\""
    assert_includes rendered, "show-controls-value=\"false\""
  end

  test "custom :class is appended to root" do
    rendered = render_component(new_map(class: "decor:shadow-md"))
    assert_includes rendered, "decor:shadow-md"
  end

  test "MapPoint exposes lat/lng/name/description" do
    point = ::Decor::Suite::Map::MapPoint.new(
      lat: 1.0,
      lng: 2.0,
      name: "n",
      description: "d"
    )
    assert_equal 1.0, point.lat
    assert_equal 2.0, point.lng
    assert_equal "n", point.name
    assert_equal "d", point.description
  end
end
