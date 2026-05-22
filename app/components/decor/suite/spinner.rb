# frozen_string_literal: true

module Decor
  module Suite
    class Spinner < ::Decor::Components::Spinner
      def view_template
        span(class: root_classes)
      end

      private

      def root_classes
        [
          "decor:inline-block decor:rounded-full decor:animate-spin",
          "decor:border-gray-200",
          size_classes,
          top_color_class
        ].join(" ")
      end

      def size_classes
        case @size
        when :xs then "decor:w-3 decor:h-3 decor:border-2"
        when :sm then "decor:w-4 decor:h-4 decor:border-[2px]"
        when :lg then "decor:w-6 decor:h-6 decor:border-[3px]"
        when :xl then "decor:w-8 decor:h-8 decor:border-[3px]"
        else "decor:w-[18px] decor:h-[18px] decor:border-[2.5px]"
        end
      end

      def top_color_class
        case @color
        when :success then "decor:border-t-suite-success-500"
        when :warning then "decor:border-t-suite-warning-500"
        when :error, :danger then "decor:border-t-suite-danger-500"
        else "decor:border-t-suite-primary-500"
        end
      end
    end
  end
end
