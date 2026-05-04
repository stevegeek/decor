# frozen_string_literal: true

module Decor
  module Daisy
    class Map < ::Decor::Components::Map
      def view_template
        root_element do
          div(
            class: map_container_classes,
            data: {**stimulus_target(:map_container)}
          )
        end
      end

      private

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
end
