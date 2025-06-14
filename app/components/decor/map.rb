# frozen_string_literal: true

module Decor
  class Map < PhlexComponent
    class MapPoint < ::Literal::Data
      prop :name, _Nilable(String)
      prop :description, _Nilable(String)
      prop :lat, Float
      prop :lng, Float
    end

    # Standard decor component attributes
    attribute :color, Symbol, default: nil, in: [:primary, :secondary, :accent, :success, :error, :warning, :info, :neutral]
    attribute :size, Symbol, default: :md, in: [:xs, :sm, :md, :lg, :xl, :full]
    attribute :disabled, :boolean, default: false

    # Map-specific attributes
    attribute :interactive, :boolean, default: true
    attribute :show_controls, :boolean, default: true
    attribute :map_type, Symbol, default: :roadmap, in: [:roadmap, :satellite, :hybrid, :terrain]

    # Core map attributes
    attribute :center, MapPoint
    attribute :points, Array, sub_type: MapPoint, default: []
    attribute :overlays, Array, default: []
    attribute :zoom, Integer, default: 10
    attribute :full_width, :boolean, default: true
    attribute :api_key, String

    # Support for custom CSS classes
    attribute :class, String

    def view_template
      render parent_element do |root|
        div(
          class: map_container_classes,
          data: root.send(:build_target_data_attributes, root.send(:parse_targets, [:map_container]))
        )
      end
    end

    private

    def root_element_attributes
      {
        values: [stimulus_values]
      }
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

    def stimulus_values
      {
        zoom: @zoom,
        center: @center.to_json,
        points: @points.to_json,
        overlays: @overlays.to_json,
        api_key: @api_key,
        interactive: @interactive.to_s,
        show_controls: @show_controls.to_s,
        map_type: @map_type.to_s,
      }
    end
  end
end
