require "test_helper"

class Decor::Daisy::MapTest < ActiveSupport::TestCase
  def setup
    @default_center = Decor::Daisy::Map::MapPoint.new(lat: 40.7128, lng: -74.0060, name: "NYC")
    @default_zoom = 10
    @default_api_key = "test_api_key"
  end

  test "renders successfully with required attributes" do
    component = Decor::Daisy::Map.new(
      center: @default_center,
      zoom: @default_zoom,
      api_key: @default_api_key
    )
    rendered = render_component(component)

    assert_includes rendered, "decor--daisy--map"
    assert_includes rendered, "data-controller"
  end

  test "renders with Stimulus controller" do
    component = Decor::Daisy::Map.new(
      center: @default_center,
      zoom: @default_zoom,
      api_key: @default_api_key
    )
    rendered = render_component(component)

    assert_includes rendered, 'data-controller="decor--daisy--map"'
  end

  test "includes center coordinates in data attributes" do
    center = Decor::Daisy::Map::MapPoint.new(lat: 37.7749, lng: -122.4194, name: "SF")
    component = Decor::Daisy::Map.new(
      center: center,
      zoom: @default_zoom,
      api_key: @default_api_key
    )
    rendered = render_component(component)

    assert_includes rendered, "37.7749"
    assert_includes rendered, "-122.4194"
  end

  test "includes zoom level in data attributes" do
    component = Decor::Daisy::Map.new(
      center: @default_center,
      zoom: 15,
      api_key: @default_api_key
    )
    rendered = render_component(component)

    assert_includes rendered, "15"
  end

  test "renders with default size (md)" do
    component = Decor::Daisy::Map.new(
      center: @default_center,
      zoom: @default_zoom,
      api_key: @default_api_key
    )
    rendered = render_component(component)

    assert_includes rendered, "h-96"
    assert_includes rendered, "w-full"
  end

  test "supports different sizes" do
    sizes = {
      xs: "h-48",
      sm: "h-64",
      md: "h-96",
      lg: "h-[28rem]",
      xl: "h-[32rem]",
      full: "h-full"
    }

    sizes.each do |size, expected_class|
      component = Decor::Daisy::Map.new(
        center: @default_center,
        zoom: @default_zoom,
        api_key: @default_api_key,
        size: size
      )
      rendered = render_component(component)

      assert_includes rendered, expected_class, "Size #{size} should include #{expected_class}"
    end
  end

  test "supports color attributes" do
    colors = [:primary, :secondary, :accent, :success, :error, :warning, :info, :neutral]

    colors.each do |color|
      component = Decor::Daisy::Map.new(
        center: @default_center,
        zoom: @default_zoom,
        api_key: @default_api_key,
        color: color
      )
      rendered = render_component(component)

      expected_class = "border-#{color}"
      assert_includes rendered, expected_class, "Color #{color} should include #{expected_class}"
    end
  end

  test "supports disabled state" do
    component = Decor::Daisy::Map.new(
      center: @default_center,
      zoom: @default_zoom,
      api_key: @default_api_key,
      disabled: true
    )
    rendered = render_component(component)

    assert_includes rendered, "pointer-events-none"
    assert_includes rendered, "cursor-not-allowed"
    assert_includes rendered, "opacity-50"
  end

  test "uses consistent background styling" do
    component = Decor::Daisy::Map.new(
      center: @default_center,
      zoom: @default_zoom,
      api_key: @default_api_key
    )
    rendered = render_component(component)

    assert_includes rendered, "bg-gray-50"
    refute_includes rendered, "data-decor--daisy--map-loading-value"
  end

  test "supports interactive controls" do
    component = Decor::Daisy::Map.new(
      center: @default_center,
      zoom: @default_zoom,
      api_key: @default_api_key,
      interactive: false,
      show_controls: false
    )
    rendered = render_component(component)

    assert_includes rendered, "data-decor--daisy--map-interactive-value=\"false\""
    assert_includes rendered, "data-decor--daisy--map-show-controls-value=\"false\""
  end

  test "supports map types" do
    map_types = [:roadmap, :satellite, :hybrid, :terrain]

    map_types.each do |map_type|
      component = Decor::Daisy::Map.new(
        center: @default_center,
        zoom: @default_zoom,
        api_key: @default_api_key,
        map_type: map_type
      )
      rendered = render_component(component)

      assert_includes rendered, "data-decor--daisy--map-map-type-value=\"#{map_type}\""
    end
  end

  test "supports points array" do
    points = [
      Decor::Daisy::Map::MapPoint.new(lat: 40.7589, lng: -73.9851, name: "Times Square"),
      Decor::Daisy::Map::MapPoint.new(lat: 40.7484, lng: -73.9857, name: "Empire State Building")
    ]

    component = Decor::Daisy::Map.new(
      center: @default_center,
      zoom: @default_zoom,
      api_key: @default_api_key,
      points: points
    )
    rendered = render_component(component)

    assert_includes rendered, "Times Square"
    assert_includes rendered, "Empire State Building"
  end

  test "supports overlays array" do
    overlays = [
      {type: "polygon", coordinates: [[[0, 0], [1, 0], [1, 1], [0, 1], [0, 0]]]}
    ]

    component = Decor::Daisy::Map.new(
      center: @default_center,
      zoom: @default_zoom,
      api_key: @default_api_key,
      overlays: overlays
    )
    rendered = render_component(component)

    assert_includes rendered, "data-decor--daisy--map-overlays-value"
  end

  test "full_width attribute works correctly" do
    component_full = Decor::Daisy::Map.new(
      center: @default_center,
      zoom: @default_zoom,
      api_key: @default_api_key,
      full_width: true
    )
    rendered_full = render_component(component_full)
    assert_includes rendered_full, "w-full"

    component_fixed = Decor::Daisy::Map.new(
      center: @default_center,
      zoom: @default_zoom,
      api_key: @default_api_key,
      full_width: false
    )
    rendered_fixed = render_component(component_fixed)
    assert_includes rendered_fixed, "w-96"
  end

  test "component inherits from PhlexComponent" do
    component = Decor::Daisy::Map.new(
      center: @default_center,
      zoom: @default_zoom,
      api_key: @default_api_key
    )

    assert component.is_a?(Decor::PhlexComponent)
  end

  test "handles various coordinate formats" do
    coordinates = [
      Decor::Daisy::Map::MapPoint.new(lat: 40.7128, lng: -74.0060, name: "NYC"),
      Decor::Daisy::Map::MapPoint.new(lat: 51.5074, lng: -0.1278, name: "London"),
      Decor::Daisy::Map::MapPoint.new(lat: -33.8688, lng: 151.2093, name: "Sydney")
    ]

    coordinates.each do |coord|
      component = Decor::Daisy::Map.new(
        center: coord,
        zoom: @default_zoom,
        api_key: @default_api_key
      )
      rendered = render_component(component)

      assert_includes rendered, coord.lat.to_s
      assert_includes rendered, coord.lng.to_s
    end
  end

  test "handles various zoom levels" do
    zoom_levels = [1, 5, 10, 15, 20]

    zoom_levels.each do |zoom|
      component = Decor::Daisy::Map.new(
        center: @default_center,
        zoom: zoom,
        api_key: @default_api_key
      )
      rendered = render_component(component)

      assert_includes rendered, zoom.to_s
    end
  end

  test "renders as div element with map classes" do
    component = Decor::Daisy::Map.new(
      center: @default_center,
      zoom: @default_zoom,
      api_key: @default_api_key
    )
    fragment = render_fragment(component)

    div = fragment.at_css("div")
    assert_not_nil div
    assert_includes div["class"], "decor--daisy--map"
    assert_includes div["class"], "h-96 w-full"
  end

  test "supports additional CSS classes" do
    component = Decor::Daisy::Map.new(
      center: @default_center,
      zoom: @default_zoom,
      api_key: @default_api_key,
      class: "custom-map-class"
    )
    rendered = render_component(component)

    assert_includes rendered, "custom-map-class"
    assert_includes rendered, "decor--daisy--map"
  end

  test "data attributes contain center and zoom information" do
    center = Decor::Daisy::Map::MapPoint.new(lat: 45.5017, lng: -73.5673, name: "Montreal")
    zoom = 12

    component = Decor::Daisy::Map.new(
      center: center,
      zoom: zoom,
      api_key: @default_api_key
    )
    fragment = render_fragment(component)

    div = fragment.at_css("div")
    assert_not_nil div

    controller_attr = div["data-controller"]
    assert_includes controller_attr, "decor--daisy--map"
  end
end
