# frozen_string_literal: true

module Decor
  module Daisy
    class Spinner < ::Decor::Components::Spinner
      def view_template
        root_element
      end

      private

      def root_element_classes
        [
          "decor:d-loading",
          style_classes,
          size_classes,
          color_classes
        ].compact.join(" ")
      end

      def component_style_classes(style)
        case style
        when :spinner then "decor:d-loading-spinner"
        when :dots then "decor:d-loading-dots"
        when :ring then "decor:d-loading-ring"
        when :ball then "decor:d-loading-ball"
        when :bars then "decor:d-loading-bars"
        when :infinity then "decor:d-loading-infinity"
        end
      end

      def component_size_classes(size)
        case size
        when :xs then "decor:d-loading-xs"
        when :sm then "decor:d-loading-sm"
        when :md then "decor:d-loading-md"
        when :lg then "decor:d-loading-lg"
        when :xl then "decor:d-loading-xl"
        end
      end

      def component_color_classes(color)
        case color
        when :base then "decor:text-base-content"
        when :primary then "decor:text-primary"
        when :secondary then "decor:text-secondary"
        when :accent then "decor:text-accent"
        when :neutral then "decor:text-neutral"
        when :info then "decor:text-info"
        when :success then "decor:text-success"
        when :warning then "decor:text-warning"
        when :error then "decor:text-error"
        end
      end
    end
  end
end
