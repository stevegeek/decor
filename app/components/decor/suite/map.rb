# frozen_string_literal: true

module Decor
  module Suite
    # Suite skin of Map. Behavior matches Daisy (Google Maps JS API loading,
    # markers, overlays, info windows). Chrome uses Suite tokens — hairline
    # border, suite card radius, neutral gray-25 placeholder surface — instead
    # of daisyUI semantic colors.
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
        classes = [
          "decor:overflow-hidden",
          "decor:rounded-suite-card",
          "decor:border",
          border_color_classes,
          size_classes
        ]
        classes << (@full_width ? "decor:w-full" : "decor:w-96")
        classes << state_classes if @disabled
        classes << @class if @class.present?
        classes.compact.join(" ")
      end

      def map_container_classes
        classes = [
          "decor:w-full",
          "decor:h-full",
          "decor:bg-suite-gray-25"
        ]
        classes << "decor:opacity-50" if @disabled
        classes.join(" ")
      end

      def border_color_classes
        case @color
        when :primary, :info then "decor:border-suite-primary-200"
        when :success then "decor:border-suite-success-100"
        when :warning then "decor:border-suite-warning-100"
        when :error, :danger then "decor:border-suite-danger-100"
        else "decor:border-suite-hairline"
        end
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

      def component_color_classes(_color)
        nil
      end

      def state_classes
        "decor:cursor-not-allowed decor:pointer-events-none"
      end
    end
  end
end
