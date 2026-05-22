# frozen_string_literal: true

module Decor
  module Daisy
    class Banner < ::Decor::Components::Banner
      private

      def root_element_attributes
        {
          html_options: {role: "alert"}
        }
      end

      def view_template
        root_element do
          if @icon
            render ::Decor::Icon.new(
              name: @icon,
              html_options: {class: "decor:h-6 decor:w-6"}
            )
          end
          div(class: wrapper_classes) do
            yield if block_given?
          end
          if @link.present?
            link_to "Learn more", @link, class: button_classes
          end
          if @call_to_action.present?
            div(class: "decor:flex decor:gap-2") do
              render @call_to_action
            end
          end
        end
      end

      def root_element_classes
        "decor:mb-4 decor:w-full decor:flex #{alert_classes}"
      end

      def wrapper_classes
        @centered ? "decor:w-full decor:justify-center decor:text-center" : "decor:flex-1"
      end

      def alert_classes
        style = case @color
        when :success
          "decor:d-alert-success"
        when :error
          "decor:d-alert-error"
        when :warning
          "decor:d-alert-warning"
        when :info
          "decor:d-alert-info"
        else
          # default color - no additional class needed
          nil
        end

        "decor:d-alert #{style}"
      end

      def button_classes
        style = case @color
        when :success
          "decor:d-btn-success"
        when :error
          "decor:d-btn-error"
        when :warning
          "decor:d-btn-warning"
        when :info
          "decor:d-btn-info"
        when :primary
          "decor:d-btn-primary"
        else
          "decor:d-btn-secondary"
        end
        "decor:d-btn decor:d-btn-sm #{style}"
      end
    end
  end
end
