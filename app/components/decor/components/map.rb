# frozen_string_literal: true

module Decor
  module Components
    class Map < ::Decor::PhlexComponent
      class MapPoint < ::Literal::Data
        prop :name, _Nilable(String)
        prop :description, _Nilable(String)
        prop :lat, Float
        prop :lng, Float
      end

      # Use unified prop system
      default_size :md
      default_color :base  # Maps typically don't need prominent colors by default

      # Map supports custom size including :full
      redefine_sizes :xs, :sm, :md, :lg, :xl, :full

      prop :disabled, _Boolean, default: false

      # Map-specific props
      prop :interactive, _Boolean, default: true
      prop :show_controls, _Boolean, default: true
      prop :map_type, _Union(:roadmap, :satellite, :hybrid, :terrain), default: :roadmap

      # Core map props
      prop :center, MapPoint
      prop :points, _Array(MapPoint), default: -> { [] }
      prop :overlays, _Array(Hash), default: -> { [] }
      prop :zoom, Integer, default: 10
      prop :full_width, _Boolean, default: true
      prop :api_key, String

      # Support for custom CSS classes
      prop :class, _Nilable(String)

      stimulus do
        targets :map_container
        values_from_props :zoom, :api_key, :interactive, :show_controls, :map_type
        values(
          center: -> { @center.to_json },
          points: -> { @points.to_json },
          overlays: -> { @overlays.to_json }
        )
      end
    end
  end
end
