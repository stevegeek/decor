# frozen_string_literal: true

module Decor
  module Daisy
    class CodeSnippet < ::Decor::Components::CodeSnippet
      private

      def view_template(&)
        code(class: root_element_classes) do
          yield if block_given?
        end
      end

      def root_element_classes
        [
          "decor:px-2 decor:py-1 decor:rounded decor:font-mono",
          size_classes,
          (@color && @color != :base) ? component_color_classes(@color) : style_classes
        ].compact.join(" ")
      end

      def component_size_classes(size)
        case size
        when :xs then "decor:text-xs"
        when :sm then "decor:text-sm"
        when :md then "decor:text-base"
        when :lg then "decor:text-lg"
        when :xl then "decor:text-xl"
        else "decor:text-base"
        end
      end

      def component_style_classes(style)
        case style
        when :filled then "decor:bg-base-200 decor:text-base-content"
        when :outlined then "decor:border decor:border-base-300 decor:text-base-content decor:bg-transparent"
        when :ghost then "decor:text-base-content decor:bg-transparent"
        else "decor:bg-base-200 decor:text-base-content"
        end
      end

      def component_color_classes(color)
        case color
        when :primary then "decor:bg-primary/20 decor:text-primary"
        when :secondary then "decor:bg-secondary/20 decor:text-secondary"
        when :accent then "decor:bg-accent/20 decor:text-accent"
        when :success then "decor:bg-success/20 decor:text-success"
        when :error then "decor:bg-error/20 decor:text-error"
        when :warning then "decor:bg-warning/20 decor:text-warning"
        when :info then "decor:bg-info/20 decor:text-info"
        else ""
        end
      end
    end
  end
end
