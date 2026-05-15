# @label Map
class ::Decor::Suite::MapPreview < ::Lookbook::Preview
  # @group Examples
  # @label Default
  def default
    render ::Decor::Suite::Map.new(
      center: san_francisco_center,
      zoom: 12,
      api_key: api_key
    )
  end

  # @group Examples
  # @label With Markers
  def with_markers
    render ::Decor::Suite::Map.new(
      center: san_francisco_center,
      points: san_francisco_points,
      zoom: 13,
      api_key: api_key
    )
  end

  # @group Examples
  # @label Outlined Primary
  def outlined_primary
    render ::Decor::Suite::Map.new(
      center: san_francisco_center,
      zoom: 12,
      color: :primary,
      api_key: api_key
    )
  end

  # @group Examples
  # @label Satellite, Large
  def satellite_large
    render ::Decor::Suite::Map.new(
      center: san_francisco_center,
      map_type: :satellite,
      size: :lg,
      zoom: 14,
      api_key: api_key
    )
  end

  # @group States
  # @label Disabled
  def disabled
    render ::Decor::Suite::Map.new(
      center: san_francisco_center,
      points: san_francisco_points,
      disabled: true,
      api_key: api_key
    )
  end

  # @group States
  # @label Non-Interactive
  def non_interactive
    render ::Decor::Suite::Map.new(
      center: san_francisco_center,
      points: san_francisco_points,
      interactive: false,
      show_controls: false,
      api_key: api_key
    )
  end

  # @group Sizes
  # @label Extra Small
  def size_xs
    render ::Decor::Suite::Map.new(center: san_francisco_center, size: :xs, api_key: api_key)
  end

  # @group Sizes
  # @label Small
  def size_sm
    render ::Decor::Suite::Map.new(center: san_francisco_center, size: :sm, api_key: api_key)
  end

  # @group Sizes
  # @label Medium
  def size_md
    render ::Decor::Suite::Map.new(center: san_francisco_center, size: :md, api_key: api_key)
  end

  # @group Sizes
  # @label Large
  def size_lg
    render ::Decor::Suite::Map.new(center: san_francisco_center, size: :lg, api_key: api_key)
  end

  # @group Sizes
  # @label Extra Large
  def size_xl
    render ::Decor::Suite::Map.new(center: san_francisco_center, size: :xl, api_key: api_key)
  end

  # @group Layout
  # @label Fixed Width
  def fixed_width
    render ::Decor::Suite::Map.new(
      center: san_francisco_center,
      full_width: false,
      api_key: api_key
    )
  end

  # @group Playground
  # @param api_key text
  # @param zoom number
  # @param size select [xs, sm, md, lg, xl, full]
  # @param color select [base, primary, success, error, warning, info]
  # @param map_type select [roadmap, satellite, hybrid, terrain]
  # @param full_width toggle
  # @param disabled toggle
  # @param interactive toggle
  # @param show_controls toggle
  # @param center_lat number
  # @param center_lng number
  # @param add_markers toggle
  def playground(
    api_key: "YOUR_API_KEY_HERE",
    zoom: 12,
    size: :md,
    color: :base,
    map_type: :roadmap,
    full_width: true,
    disabled: false,
    interactive: true,
    show_controls: true,
    center_lat: 37.7749,
    center_lng: -122.4194,
    add_markers: true
  )
    center = ::Decor::Suite::Map::MapPoint.new(
      lat: center_lat.to_f,
      lng: center_lng.to_f,
      name: "Center Point",
      description: "Map center location"
    )

    points = add_markers ? [
      ::Decor::Suite::Map::MapPoint.new(
        lat: center_lat.to_f + 0.01,
        lng: center_lng.to_f + 0.01,
        name: "Marker 1",
        description: "First sample marker"
      ),
      ::Decor::Suite::Map::MapPoint.new(
        lat: center_lat.to_f - 0.01,
        lng: center_lng.to_f - 0.01,
        name: "Marker 2",
        description: "Second sample marker"
      )
    ] : []

    render ::Decor::Suite::Map.new(
      center: center,
      points: points,
      zoom: zoom.to_i,
      size: size.to_sym,
      color: color.to_sym,
      map_type: map_type.to_sym,
      full_width: full_width,
      disabled: disabled,
      interactive: interactive,
      show_controls: show_controls,
      api_key: api_key
    )
  end

  private

  # Pulled from ENV at preview-render time so the gem source never bakes in a
  # key. Falls back to a placeholder; without a real key the embedded map
  # surface stays gray but layout/typography are still inspectable.
  def api_key
    ENV.fetch("GOOGLE_MAPS_API_KEY", "YOUR_API_KEY_HERE")
  end

  def san_francisco_center
    ::Decor::Suite::Map::MapPoint.new(
      lat: 37.7749,
      lng: -122.4194,
      name: "San Francisco",
      description: "The Golden City"
    )
  end

  def san_francisco_points
    [
      ::Decor::Suite::Map::MapPoint.new(
        lat: 37.7849,
        lng: -122.4094,
        name: "Nob Hill",
        description: "Historic neighborhood with cable cars"
      ),
      ::Decor::Suite::Map::MapPoint.new(
        lat: 37.7649,
        lng: -122.4294,
        name: "Mission District",
        description: "Vibrant cultural area with street art"
      ),
      ::Decor::Suite::Map::MapPoint.new(
        lat: 37.7849,
        lng: -122.4394,
        name: "Golden Gate Park",
        description: "Large urban park with gardens and museums"
      )
    ]
  end
end
