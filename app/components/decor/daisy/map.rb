# frozen_string_literal: true

module Decor
  module Daisy
    class Map < ::Decor::Components::Map
      def view_template
        root_element do
          # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
          div(
            class: map_container_classes,
            data: {**stimulus_target(:map_container)}
          )
        end
      end

      private

      def root_element_classes
        classes = [size_classes]
        classes << "decor:w-full" if @full_width
        classes << "decor:w-96" unless @full_width
        classes << "decor:border-2" << color_classes if @color && @color != :base
        classes << state_classes
        classes << @class if @class.present?
        classes.compact.join(" ")
      end

      def map_container_classes
        classes = ["decor:w-full", "decor:h-full", "decor:bg-gray-50"]
        classes << "decor:opacity-50" if @disabled
        classes.join(" ")
      end

      def component_size_classes(size)
        case size
        when :xs then "decor:h-48"
        when :sm then "decor:h-64"
        when :md then "decor:h-96"
        when :lg then "decor:h-[28rem]"
        when :xl then "decor:h-[32rem]"
        when :full then "decor:h-full"
        else "decor:h-96"
        end
      end

      def component_color_classes(color)
        case color
        when :primary then "decor:border-primary"
        when :secondary then "decor:border-secondary"
        when :accent then "decor:border-accent"
        when :success then "decor:border-success"
        when :error then "decor:border-error"
        when :warning then "decor:border-warning"
        when :info then "decor:border-info"
        when :neutral then "decor:border-neutral"
        when :base then "decor:border-base-300"
        else "decor:border-base-300"
        end
      end

      def state_classes
        "decor:cursor-not-allowed decor:pointer-events-none" if @disabled
      end
    end
  end
end
