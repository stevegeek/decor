# frozen_string_literal: true

module Decor
  class Map < PhlexComponent
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

    def root_element_classes
      classes = [size_classes]
      classes << "w-full" if @full_width
      classes << "w-96" unless @full_width
      classes << "border-2" << color_classes if @color && @color != :base
      classes << state_classes
      classes << @class if @class.present?
      classes.compact.join(" ")
    end

    def map_container_classes
      classes = ["w-full", "h-full", "bg-gray-50"]
      classes << "opacity-50" if @disabled
      classes.join(" ")
    end

    def component_size_classes(size)
      case size
      when :xs then "h-48"
      when :sm then "h-64"
      when :md then "h-96"
      when :lg then "h-[28rem]"
      when :xl then "h-[32rem]"
      when :full then "h-full"
      else "h-96"
      end
    end

    def component_color_classes(color)
      case color
      when :primary then "border-primary"
      when :secondary then "border-secondary"
      when :accent then "border-accent"
      when :success then "border-success"
      when :error then "border-error"
      when :warning then "border-warning"
      when :info then "border-info"
      when :neutral then "border-neutral"
      when :base then "border-base-300"
      else "border-base-300"
      end
    end

    def state_classes
      "cursor-not-allowed pointer-events-none" if @disabled
    end
  end
end
