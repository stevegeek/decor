# frozen_string_literal: true

module Decor
  module Daisy
    # A standard 'tooltip' or popover component
    class Tooltip < ::Decor::Components::Tooltip
      def view_template(&)
        @content = capture(&).html_safe if block_given?

        root_element(
          data: {
            tip: rendered_tip_content # This is set after the capture
          }
        ) do
          raw @content if @content.present?
        end
      end

      private

      def root_element_classes
        classes = ["decor:d-tooltip"]
        classes << position_class
        classes << size_classes
        classes << color_classes
        classes << style_classes
        classes.compact.join(" ")
      end

      def position_class
        case @position
        when :top, nil then "decor:d-tooltip-top"
        when :bottom then "decor:d-tooltip-bottom"
        when :left then "decor:d-tooltip-left"
        when :right then "decor:d-tooltip-right"
        else "decor:d-tooltip-top"
        end
      end

      def component_size_classes(size)
        # DaisyUI tooltip sizes
        case size
        when :xs then "decor:d-tooltip-xs"
        when :sm then "decor:d-tooltip-sm"
        when :md then nil # default
        when :lg then "decor:d-tooltip-lg"
        when :xl then "decor:d-tooltip-xl"
        end
      end

      def component_color_classes(color)
        case color
        when :base then nil # default
        when :primary then "decor:d-tooltip-primary"
        when :secondary then "decor:d-tooltip-secondary"
        when :accent then "decor:d-tooltip-accent"
        when :success then "decor:d-tooltip-success"
        when :error then "decor:d-tooltip-error"
        when :warning then "decor:d-tooltip-warning"
        when :info then "decor:d-tooltip-info"
        when :neutral then "decor:d-tooltip-neutral"
        end
      end

      def component_style_classes(style)
        case style
        when :filled then nil # default
        when :outlined then "decor:d-tooltip-outline"
        when :ghost then "decor:d-tooltip-ghost"
        end
      end

      def root_element_attributes
        {
          element_tag: :div
        }
      end

      def rendered_tip_content
        return @tip_text if @tip_text.present?
        return nil unless @tip_content
        # Render the block content to a string
        capture(&@tip_content)
      end

      def tooltip_content_classes
        "decor:d-tooltip-content"
      end
    end
  end
end
