# frozen_string_literal: true

module Decor
  module Daisy
    class Link < ::Decor::Components::Link
      include ::Decor::Daisy::ButtonTemplate

      private

      def root_element_classes
        [
          "decor:d-btn decor:d-btn-link",
          *color_classes,
          *size_classes,
          *style_classes,
          *modifier_classes
        ].compact.join(" ")
      end

      def component_color_classes(color)
        return [] unless color

        case color
        when :primary
          ["decor:d-link-primary"]
        when :secondary
          ["decor:d-link-secondary"]
        when :error
          ["decor:d-link-error"]
        when :warning
          ["decor:d-link-warning"]
        when :neutral
          ["decor:d-link-neutral"]
        when :success
          ["decor:d-link-success"]
        when :info
          ["decor:d-link-info"]
        when :accent
          ["decor:d-link-accent"]
        else
          ["decor:d-link-primary"]
        end
      end

      def component_size_classes(size)
        case size
        when :xs
          ["decor:text-xs"]
        when :sm
          ["decor:text-sm"]
        when :lg
          ["decor:text-lg"]
        when :xl
          ["decor:text-xl"]
        else
          ["decor:text-base"] # Default for md
        end
      end

      def modifier_classes
        classes = []
        if @disabled
          classes << "decor:text-gray-400"
          classes << "decor:cursor-not-allowed"
          classes << "decor:no-underline"
        end
        classes
      end
    end
  end
end
