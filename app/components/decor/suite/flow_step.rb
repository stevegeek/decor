# frozen_string_literal: true

module Decor
  module Suite
    # Suite FlowStep — chunky step indicator with card-chromed child-block
    # content area. Step circle uses suite-* numbered shades; child block
    # carries a tinted-card chrome (muted gray-25 surface + hairline border).
    class FlowStep < ::Decor::Daisy::FlowStep
      def view_template(&)
        root_element do
          render_step_indicator

          div(class: "decor:flex-1 decor:min-w-0") do
            h4(class: "decor:suite-section-title decor:m-0 decor:mb-[3px]") { @title }
            if @description.present?
              p(class: "decor:suite-description decor:text-gray-500 decor:m-0 decor:mb-3 decor:leading-[1.55] decor:max-w-[540px]") { @description }
            end

            if block_given?
              div(class: child_block_classes, &)
            end
          end
        end
      end

      private

      def root_element_classes
        "decor:flex decor:gap-4 decor:px-5 decor:py-4 decor:pb-5 decor:border-b decor:border-suite-hairline decor:last:border-b-0"
      end

      def child_block_classes
        "decor:mt-2.5 decor:px-3.5 decor:py-3 decor:bg-suite-gray-25 decor:border decor:border-suite-hairline decor:rounded-suite-card decor:text-xs decor:text-gray-500"
      end

      def step_indicator_classes
        [
          "decor:shrink-0 decor:w-[38px] decor:h-[38px] decor:flex decor:items-center decor:justify-center decor:rounded-full decor:border-2 decor:font-bold decor:suite-dense-body decor:tabular-nums",
          component_style_classes(@style)
        ].compact.join(" ")
      end

      def filled_color_classes(color)
        case color
        when :primary, :info then "decor:bg-suite-primary-50 decor:border-suite-primary-300 decor:text-suite-primary-700"
        when :success then "decor:bg-suite-success-50 decor:border-suite-success-500 decor:text-suite-success-700"
        when :warning then "decor:bg-suite-warning-50 decor:border-suite-warning-500 decor:text-suite-warning-700"
        when :error then "decor:bg-suite-danger-50 decor:border-suite-danger-500 decor:text-suite-danger-700"
        when :neutral then "decor:bg-gray-100 decor:border-suite-hairline-strong decor:text-gray-700"
        when :secondary then "decor:bg-gray-100 decor:border-suite-hairline-strong decor:text-gray-700"
        when :accent then "decor:bg-suite-warning-50 decor:border-suite-warning-500 decor:text-suite-warning-700"
        end
      end

      def outline_color_classes(color)
        case color
        when :primary, :info then "decor:border-2 decor:border-suite-primary-300 decor:text-suite-primary-700 decor:bg-transparent"
        when :success then "decor:border-2 decor:border-suite-success-500 decor:text-suite-success-700 decor:bg-transparent"
        when :warning then "decor:border-2 decor:border-suite-warning-500 decor:text-suite-warning-700 decor:bg-transparent"
        when :error then "decor:border-2 decor:border-suite-danger-500 decor:text-suite-danger-700 decor:bg-transparent"
        when :neutral then "decor:border-2 decor:border-suite-hairline-strong decor:text-gray-700 decor:bg-transparent"
        when :secondary then "decor:border-2 decor:border-suite-hairline-strong decor:text-gray-700 decor:bg-transparent"
        when :accent then "decor:border-2 decor:border-suite-warning-500 decor:text-suite-warning-700 decor:bg-transparent"
        end
      end

      def ghost_color_classes(color)
        case color
        when :primary, :info then "decor:border-2 decor:border-transparent decor:text-suite-primary-700 decor:hover:bg-suite-primary-50"
        when :success then "decor:border-2 decor:border-transparent decor:text-suite-success-700 decor:hover:bg-suite-success-50"
        when :warning then "decor:border-2 decor:border-transparent decor:text-suite-warning-700 decor:hover:bg-suite-warning-50"
        when :error then "decor:border-2 decor:border-transparent decor:text-suite-danger-700 decor:hover:bg-suite-danger-50"
        when :neutral then "decor:border-2 decor:border-transparent decor:text-gray-700 decor:hover:bg-gray-100"
        when :secondary then "decor:border-2 decor:border-transparent decor:text-gray-700 decor:hover:bg-gray-100"
        when :accent then "decor:border-2 decor:border-transparent decor:text-suite-warning-700 decor:hover:bg-suite-warning-50"
        end
      end
    end
  end
end
