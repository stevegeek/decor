# frozen_string_literal: true

require "test_helper"

class Decor::Suite::PolygonEditorTest < ActiveSupport::TestCase
  def new_editor(**overrides)
    ::Decor::Suite::PolygonEditor.new(
      api_key: "test-key",
      input_name: "serviceability[region_geo_json]",
      input_id: "serviceability_region_geo_json",
      **overrides
    )
  end

  test "renders helper copy describing how to draw the polygon" do
    rendered = render_component(new_editor)
    assert_includes rendered, "Click the polygon tool on the map to draw your service area"
  end

  test "renders a Clear and redraw polygon button wired to the clear_polygon action" do
    rendered = render_component(new_editor)
    assert_includes rendered, "Clear and redraw polygon"
    assert_includes rendered, "decor--suite--polygon-editor#clearPolygon"
  end

  test "clear button uses suite-primary palette + suite-description token" do
    rendered = render_component(new_editor)
    assert_includes rendered, "decor:text-suite-primary-500"
    assert_includes rendered, "decor:hover:text-suite-primary-700"
    assert_includes rendered, "decor:suite-description"
  end

  test "map container uses suite gray-25 surface, suite hairline border, and suite card radius" do
    rendered = render_component(new_editor)
    assert_includes rendered, "decor:bg-suite-gray-25"
    assert_includes rendered, "decor:border-suite-hairline"
    assert_includes rendered, "decor:rounded-suite-card"
    assert_includes rendered, "decor:h-96"
  end

  test "map container carries the map_container stimulus target" do
    rendered = render_component(new_editor)
    assert_includes rendered, "decor--suite--polygon-editor-target=\"mapContainer\""
  end

  test "renders a hidden input bound to the geo_json_input stimulus target" do
    rendered = render_component(new_editor)
    assert_includes rendered, "type=\"hidden\""
    assert_includes rendered, "name=\"serviceability[region_geo_json]\""
    assert_includes rendered, "id=\"serviceability_region_geo_json\""
    assert_includes rendered, "decor--suite--polygon-editor-target=\"geoJsonInput\""
  end

  test "initial_polygon value populates the hidden input value" do
    polygon = '{"type":"MultiPolygon","coordinates":[[[[1,2],[3,4],[5,6],[1,2]]]]}'
    rendered = render_component(new_editor(initial_polygon: polygon))
    assert_includes rendered, "MultiPolygon"
  end

  test "carries api_key as a stimulus value" do
    rendered = render_component(new_editor(api_key: "abc123"))
    assert_includes rendered, "api-key-value=\"abc123\""
  end

  test "carries zoom as a stimulus value with the default of 10" do
    rendered = render_component(new_editor)
    assert_includes rendered, "zoom-value=\"10\""
  end

  test "center hash is serialised to JSON for the stimulus center value" do
    rendered = render_component(new_editor(center: {lat: 37.7749, lng: -122.4194}))
    assert_includes rendered, "center-value="
    assert_includes rendered, "37.7749"
    assert_includes rendered, "-122.4194"
  end

  test "empty center hash omits the center value JSON payload" do
    rendered = render_component(new_editor)
    refute_includes rendered, "\"lat\":"
  end

  test "root element uses w-full" do
    rendered = render_component(new_editor)
    assert_includes rendered, "decor:w-full"
  end
end
