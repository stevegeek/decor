# frozen_string_literal: true

module Decor
  class Map < PhlexComponent
    class MapPoint < ::Literal::Data
      prop :name, _Nilable(String)
      prop :description, _Nilable(String)
      prop :lat, Float
      prop :lng, Float
    end

    # Standard decor component props
    prop :color, _Nilable(_Union(:primary, :secondary, :accent, :success, :error, :warning, :info, :neutral))
    prop :size, _Union(:xs, :sm, :md, :lg, :xl, :full), default: :md
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

    def view_template
      root_element do
        div(
          class: map_container_classes,
          data: {**stimulus_target(:map_container)}
        )
      end
    end

    private

    stimulus do
      targets :map_container
      values_from_props :zoom, :api_key, :interactive, :show_controls, :map_type
      values(
        center: -> { @center.to_json },
        points: -> { @points.to_json },
        overlays: -> { @overlays.to_json }
      )
    end

    def element_classes
      classes = [base_size_class]
      classes << "w-full" if @full_width
      classes << "w-96" unless @full_width
      classes << "border-2 #{color_classes}" if @color
      classes << state_classes
      classes << @class if @class.present?
      classes.compact.join(" ")
    end

    def map_container_classes
      classes = ["w-full", "h-full", "bg-gray-50"]
      classes << "opacity-50" if @disabled
      classes.join(" ")
    end

    def base_size_class
      case @size
      when :xs then "h-48"
      when :sm then "h-64"
      when :md then "h-96"
      when :lg then "h-[28rem]"
      when :xl then "h-[32rem]"
      when :full then "h-full"
      else "h-96"
      end
    end

    def color_classes
      case @color
      when :primary then "border-primary"
      when :secondary then "border-secondary"
      when :accent then "border-accent"
      when :success then "border-success"
      when :error then "border-error"
      when :warning then "border-warning"
      when :info then "border-info"
      else "border-gray-200"
      end
    end

    def state_classes
      "cursor-not-allowed pointer-events-none" if @disabled
    end
  end
end
