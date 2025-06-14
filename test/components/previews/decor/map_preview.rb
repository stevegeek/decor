# @label Map
class ::Decor::MapPreview < ::Lookbook::Preview
  # Maps
  # -------
  #
  # An embedded Google Maps component with enhanced security, error handling, and standardized attributes.
  # Supports different sizes, colors, and states with markers, overlays, and various map types.

  # @label Playground
  # @param api_key text
  # @param zoom number
  # @param size select [xs, sm, md, lg, xl, full]
  # @param color select [primary, secondary, accent, success, error, warning, info, neutral]
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
    color: :neutral,
    map_type: :roadmap,
    full_width: true,
    disabled: false,
    interactive: true,
    show_controls: true,
    center_lat: 37.7749,
    center_lng: 122.4194,
    add_markers: true
  )
    center = ::Decor::Map::MapPoint.new(
      lat: center_lat,
      lng: center_lng,
      name: "Center Point",
      description: "Map center location"
    )

    points = add_markers ? [
      ::Decor::Map::MapPoint.new(
        lat: center_lat + 0.01,
        lng: center_lng + 0.01,
        name: "Marker 1",
        description: "First sample marker"
      ),
      ::Decor::Map::MapPoint.new(
        lat: center_lat - 0.01,
        lng: center_lng - 0.01,
        name: "Marker 2",
        description: "Second sample marker"
      )
    ] : []

    render ::Decor::Map.new(
      center: center,
      points: points,
      zoom: zoom,
      size: size,
      color: color,
      map_type: map_type,
      full_width: full_width,
      disabled: disabled,
      interactive: interactive,
      show_controls: show_controls,
      api_key: api_key
    )
  end

  # @group Colors
  # @label Primary Color
  # @param api_key text
  def color_primary(api_key: "Key please")
    render ::Decor::Map.new(
      center: san_francisco_center,
      color: :primary,
      api_key: api_key
    )
  end

  # @group Colors
  # @label Secondary Color
  # @param api_key text
  def color_secondary(api_key: "Key please")
    render ::Decor::Map.new(
      center: san_francisco_center,
      color: :secondary,
      api_key: api_key
    )
  end

  # @group Colors
  # @label Accent Color
  # @param api_key text
  def color_accent(api_key: "Key please")
    render ::Decor::Map.new(
      center: san_francisco_center,
      color: :accent,
      api_key: api_key
    )
  end

  # @group Colors
  # @label Success Color
  # @param api_key text
  def color_success(api_key: "Key please")
    render ::Decor::Map.new(
      center: san_francisco_center,
      color: :success,
      api_key: api_key
    )
  end

  # @group Colors
  # @label Error Color
  # @param api_key text
  def color_error(api_key: "Key please")
    render ::Decor::Map.new(
      center: san_francisco_center,
      color: :error,
      api_key: api_key
    )
  end

  # @group Colors
  # @label Warning Color
  # @param api_key text
  def color_warning(api_key: "Key please")
    render ::Decor::Map.new(
      center: san_francisco_center,
      color: :warning,
      api_key: api_key
    )
  end

  # @group Colors
  # @label Info Color
  # @param api_key text
  def color_info(api_key: "Key please")
    render ::Decor::Map.new(
      center: san_francisco_center,
      color: :info,
      api_key: api_key
    )
  end

  # @group Colors
  # @label Neutral Color
  # @param api_key text
  def color_neutral(api_key: "Key please")
    render ::Decor::Map.new(
      center: san_francisco_center,
      color: :neutral,
      api_key: api_key
    )
  end


  # @group Sizes
  # @label Extra Small Size (xs)
  # @param api_key text
  def size_xs(api_key: "Key please")
    render ::Decor::Map.new(
      center: san_francisco_center,
      size: :xs,
      api_key: api_key
    )
  end

  # @group Sizes
  # @label Small Size (sm)
  # @param api_key text
  def size_sm(api_key: "Key please")
    render ::Decor::Map.new(
      center: san_francisco_center,
      size: :sm,
      api_key: api_key
    )
  end

  # @group Sizes
  # @label Medium Size (md)
  # @param api_key text
  def size_md(api_key: "Key please")
    render ::Decor::Map.new(
      center: san_francisco_center,
      size: :md,
      api_key: api_key
    )
  end

  # @group Sizes
  # @label Large Size (lg)
  # @param api_key text
  def size_lg(api_key: "Key please")
    render ::Decor::Map.new(
      center: san_francisco_center,
      size: :lg,
      api_key: api_key
    )
  end

  # @group Sizes
  # @label Extra Large Size (xl)
  # @param api_key text
  def size_xl(api_key: "Key please")
    render ::Decor::Map.new(
      center: san_francisco_center,
      size: :xl,
      api_key: api_key
    )
  end

  # @group Sizes
  # @label Full Size
  # @param api_key text
  def size_full(api_key: "Key please")
    render ::Decor::Map.new(
      center: san_francisco_center,
      size: :full,
      api_key: api_key
    )
  end

  # @group Map Types
  # @label Roadmap Type
  # @param api_key text
  def map_type_roadmap(api_key: "Key please")
    render ::Decor::Map.new(
      center: new_york_center,
      map_type: :roadmap,
      zoom: 14,
      api_key: api_key
    )
  end

  # @group Map Types
  # @label Satellite Type
  # @param api_key text
  def map_type_satellite(api_key: "Key please")
    render ::Decor::Map.new(
      center: new_york_center,
      map_type: :satellite,
      zoom: 14,
      api_key: api_key
    )
  end

  # @group Map Types
  # @label Hybrid Type
  # @param api_key text
  def map_type_hybrid(api_key: "Key please")
    render ::Decor::Map.new(
      center: new_york_center,
      map_type: :hybrid,
      zoom: 14,
      api_key: api_key
    )
  end

  # @group Map Types
  # @label Terrain Type
  # @param api_key text
  def map_type_terrain(api_key: "Key please")
    render ::Decor::Map.new(
      center: mountain_center,
      map_type: :terrain,
      zoom: 10,
      api_key: api_key
    )
  end

  # @group With Markers
  # @label Single Marker
  # @param api_key text
  def markers_single(api_key: "Key please")
    render ::Decor::Map.new(
      center: london_center,
      points: [london_center],
      zoom: 13,
      api_key: api_key
    )
  end

  # @group With Markers
  # @label Multiple Markers
  # @param api_key text
  def markers_multiple(api_key: "Key please")
    render ::Decor::Map.new(
      center: san_francisco_center,
      points: san_francisco_points,
      zoom: 13,
      color: :primary,
      api_key: api_key
    )
  end

  # @group With Markers
  # @label City Tour Markers
  # @param api_key text
  def markers_city_tour(api_key: "Key please")
    render ::Decor::Map.new(
      center: paris_center,
      points: paris_points,
      zoom: 14,
      color: :accent,
      api_key: api_key
    )
  end

  # @group With Markers
  # @label Business Locations
  # @param api_key text
  def markers_business(api_key: "Key please")
    render ::Decor::Map.new(
      center: tokyo_center,
      points: tokyo_points,
      zoom: 12,
      color: :success,
      size: :lg,
      api_key: api_key
    )
  end


  # @group States
  # @label Disabled State
  # @param api_key text
  def state_disabled(api_key: "Key please")
    render ::Decor::Map.new(
      center: san_francisco_center,
      points: san_francisco_points,
      disabled: true,
      api_key: api_key
    )
  end

  # @group States
  # @label Non-Interactive
  # @param api_key text
  def state_non_interactive(api_key: "Key please")
    render ::Decor::Map.new(
      center: san_francisco_center,
      points: san_francisco_points,
      interactive: false,
      show_controls: false,
      api_key: api_key
    )
  end


  # @group Layout
  # @label Full Width
  # @param api_key text
  def layout_full_width(api_key: "Key please")
    render ::Decor::Map.new(
      center: san_francisco_center,
      full_width: true,
      api_key: api_key
    )
  end

  # @group Layout
  # @label Fixed Width
  # @param api_key text
  def layout_fixed_width(api_key: "Key please")
    render ::Decor::Map.new(
      center: san_francisco_center,
      full_width: false,
      api_key: api_key
    )
  end

  # @group Layout
  # @label Full Width Large
  # @param api_key text
  def layout_full_width_large(api_key: "Key please")
    render ::Decor::Map.new(
      center: san_francisco_center,
      full_width: true,
      size: :lg,
      color: :primary,
      api_key: api_key
    )
  end

  # @group Layout
  # @label Full Width with Markers
  # @param api_key text
  def layout_full_width_markers(api_key: "Key please")
    render ::Decor::Map.new(
      center: san_francisco_center,
      points: san_francisco_points,
      full_width: true,
      size: :xl,
      color: :accent,
      api_key: api_key
    )
  end

  # @group Combinations
  # @label Large Primary with Markers
  # @param api_key text
  def combo_large_primary_markers(api_key: "Key please")
    render ::Decor::Map.new(
      center: london_center,
      points: london_points,
      size: :lg,
      color: :primary,
      zoom: 13,
      api_key: api_key
    )
  end

  # @group Combinations
  # @label Satellite View Business Map
  # @param api_key text
  def combo_satellite_business(api_key: "Key please")
    render ::Decor::Map.new(
      center: tokyo_center,
      points: tokyo_points,
      map_type: :satellite,
      color: :success,
      size: :lg,
      zoom: 15,
      api_key: api_key
    )
  end

  # @group Combinations
  # @label Terrain Explorer
  # @param api_key text
  def combo_terrain_explorer(api_key: "Key please")
    render ::Decor::Map.new(
      center: mountain_center,
      points: mountain_points,
      map_type: :terrain,
      color: :warning,
      size: :xl,
      zoom: 10,
      api_key: api_key
    )
  end

  # @group Combinations
  # @label City Guide Hybrid
  # @param api_key text
  def combo_city_guide_hybrid(api_key: "Key please")
    render ::Decor::Map.new(
      center: paris_center,
      points: paris_points,
      map_type: :hybrid,
      color: :accent,
      size: :lg,
      zoom: 14,
      full_width: true,
      api_key: api_key
    )
  end

  # @group Error Scenarios
  # @label Invalid API Key
  # @param api_key text
  def error_invalid_api_key(api_key: "Key please")
    render ::Decor::Map.new(
      center: san_francisco_center,
      api_key: "invalid_key_demo"
    )
  end

  # @group Error Scenarios
  # @label Network Error Simulation
  # @param api_key text
  def error_network(api_key: "Key please")
    render ::Decor::Map.new(
      center: san_francisco_center,
      api_key: "demo_network_error"
    )
  end

  # @group Advanced Features
  # @label Custom Overlays
  # @param api_key text
  def advanced_overlays(api_key: "Key please")
    overlays = [
      {
        type: "polygon",
        coordinates: [
          [
            [-122.4194, 37.7749],
            [-122.4094, 37.7749],
            [-122.4094, 37.7849],
            [-122.4194, 37.7849],
            [-122.4194, 37.7749]
          ]
        ]
      }
    ]

    render ::Decor::Map.new(
      center: san_francisco_center,
      overlays: overlays,
      zoom: 14,
      color: :info,
      api_key: api_key
    )
  end

  # @group Advanced Features
  # @label High Density Markers
  # @param api_key text
  def advanced_high_density(api_key: "Key please")
    render ::Decor::Map.new(
      center: manhattan_center,
      points: manhattan_points,
      zoom: 13,
      color: :primary,
      size: :lg,
      api_key: api_key
    )
  end

  private

  # Helper methods for consistent test data

  # @param api_key text
  def san_francisco_center(api_key: "Key please")
    ::Decor::Map::MapPoint.new(
      lat: 37.7749,
      lng: -122.4194,
      name: "San Francisco",
      description: "The Golden City"
    )
  end

  # @param api_key text
  def san_francisco_points(api_key: "Key please")
    [
      ::Decor::Map::MapPoint.new(
        lat: 37.7849,
        lng: -122.4094,
        name: "Nob Hill",
        description: "Historic neighborhood with cable cars"
      ),
      ::Decor::Map::MapPoint.new(
        lat: 37.7649,
        lng: -122.4294,
        name: "Mission District",
        description: "Vibrant cultural area with street art"
      ),
      ::Decor::Map::MapPoint.new(
        lat: 37.7849,
        lng: -122.4394,
        name: "Golden Gate Park",
        description: "Large urban park with gardens and museums"
      )
    ]
  end

  # @param api_key text
  def new_york_center(api_key: "Key please")
    ::Decor::Map::MapPoint.new(
      lat: 40.7128,
      lng: -74.0060,
      name: "New York City",
      description: "The Big Apple"
    )
  end

  # @param api_key text
  def london_center(api_key: "Key please")
    ::Decor::Map::MapPoint.new(
      lat: 51.5074,
      lng: -0.1278,
      name: "London",
      description: "Historic capital of England"
    )
  end

  # @param api_key text
  def london_points(api_key: "Key please")
    [
      london_center,
      ::Decor::Map::MapPoint.new(
        lat: 51.5014,
        lng: -0.1419,
        name: "Buckingham Palace",
        description: "Official residence of the British monarch"
      ),
      ::Decor::Map::MapPoint.new(
        lat: 51.5045,
        lng: -0.0865,
        name: "Tower of London",
        description: "Historic castle and former royal residence"
      )
    ]
  end

  # @param api_key text
  def paris_center(api_key: "Key please")
    ::Decor::Map::MapPoint.new(
      lat: 48.8566,
      lng: 2.3522,
      name: "Paris",
      description: "City of Light"
    )
  end

  # @param api_key text
  def paris_points(api_key: "Key please")
    [
      ::Decor::Map::MapPoint.new(
        lat: 48.8584,
        lng: 2.2945,
        name: "Eiffel Tower",
        description: "Iconic iron lattice tower"
      ),
      ::Decor::Map::MapPoint.new(
        lat: 48.8606,
        lng: 2.3376,
        name: "Louvre Museum",
        description: "World's largest art museum"
      ),
      ::Decor::Map::MapPoint.new(
        lat: 48.8530,
        lng: 2.3499,
        name: "Notre-Dame",
        description: "Medieval Catholic cathedral"
      )
    ]
  end

  # @param api_key text
  def tokyo_center(api_key: "Key please")
    ::Decor::Map::MapPoint.new(
      lat: 35.6762,
      lng: 139.6503,
      name: "Tokyo",
      description: "Capital of Japan"
    )
  end

  # @param api_key text
  def tokyo_points(api_key: "Key please")
    [
      ::Decor::Map::MapPoint.new(
        lat: 35.6584,
        lng: 139.7016,
        name: "Tokyo Skytree",
        description: "Broadcasting and observation tower"
      ),
      ::Decor::Map::MapPoint.new(
        lat: 35.6854,
        lng: 139.7531,
        name: "Senso-ji Temple",
        description: "Ancient Buddhist temple in Asakusa"
      ),
      ::Decor::Map::MapPoint.new(
        lat: 35.6895,
        lng: 139.6917,
        name: "Imperial Palace",
        description: "Primary residence of the Emperor of Japan"
      )
    ]
  end

  # @param api_key text
  def mountain_center(api_key: "Key please")
    ::Decor::Map::MapPoint.new(
      lat: 46.8182,
      lng: 8.2275,
      name: "Swiss Alps",
      description: "Mountain range in Switzerland"
    )
  end

  # @param api_key text
  def mountain_points(api_key: "Key please")
    [
      ::Decor::Map::MapPoint.new(
        lat: 46.9480,
        lng: 7.4474,
        name: "Jungfraujoch",
        description: "Top of Europe - highest railway station"
      ),
      ::Decor::Map::MapPoint.new(
        lat: 45.9763,
        lng: 7.6586,
        name: "Matterhorn",
        description: "Iconic pyramid-shaped mountain peak"
      )
    ]
  end

  # @param api_key text
  def manhattan_center(api_key: "Key please")
    ::Decor::Map::MapPoint.new(
      lat: 40.7589,
      lng: -73.9851,
      name: "Times Square",
      description: "Commercial intersection in Midtown Manhattan"
    )
  end

  # @param api_key text
  def manhattan_points(api_key: "Key please")
    [
      manhattan_center,
      ::Decor::Map::MapPoint.new(
        lat: 40.7484,
        lng: -73.9857,
        name: "Empire State Building",
        description: "Art Deco skyscraper in Midtown"
      ),
      ::Decor::Map::MapPoint.new(
        lat: 40.7614,
        lng: -73.9776,
        name: "Central Park",
        description: "Large public park in Manhattan"
      ),
      ::Decor::Map::MapPoint.new(
        lat: 40.7505,
        lng: -73.9934,
        name: "High Line",
        description: "Elevated linear park on former railway"
      ),
      ::Decor::Map::MapPoint.new(
        lat: 40.7410,
        lng: -74.0014,
        name: "One World Trade Center",
        description: "Main building of rebuilt World Trade Center"
      )
    ]
  end
end
