# frozen_string_literal: true

module Decor
  module Suite
    class CodeSnippet < ::Decor::Components::CodeSnippet
      private

      def view_template(&)
        code(class: root_element_classes) do
          yield if block_given?
        end
      end

      def root_element_classes
        [
          "decor:inline decor:font-mono decor:rounded-suite-control decor:px-1.5 decor:py-0.5 decor:whitespace-nowrap",
          size_classes,
          (@color && @color != :base) ? component_color_classes(@color) : style_classes
        ].compact.join(" ")
      end

      def component_size_classes(size)
        case size
        when :xs then "decor:text-[10px]"
        when :sm then "decor:suite-description"
        when :lg then "decor:text-sm"
        when :xl then "decor:text-base"
        else "decor:text-xs" # :md — Suite snippets read smaller than Daisy
        end
      end

      def component_style_classes(style)
        case style
        when :outlined then "decor:bg-transparent decor:border decor:border-suite-hairline decor:text-gray-800"
        when :ghost then "decor:bg-transparent decor:text-gray-800"
        else # :filled
          "decor:bg-suite-gray-25 decor:border decor:border-suite-hairline decor:text-gray-800"
        end
      end

      def component_color_classes(color)
        case color
        when :primary then "decor:bg-suite-primary-50 decor:text-suite-primary-700 decor:border decor:border-suite-primary-200"
        when :success then "decor:bg-suite-success-50 decor:text-suite-success-700 decor:border decor:border-suite-success-100"
        when :warning then "decor:bg-suite-warning-50 decor:text-suite-warning-700 decor:border decor:border-suite-warning-100"
        when :error then "decor:bg-suite-danger-50 decor:text-suite-danger-700 decor:border decor:border-suite-danger-100"
        when :info then "decor:bg-suite-primary-50 decor:text-suite-primary-700 decor:border decor:border-suite-primary-200"
        else ""
        end
      end
    end
  end
end
