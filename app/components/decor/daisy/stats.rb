# frozen_string_literal: true

module Decor
  module Daisy
    # Container component for grouping multiple Stat components in a row or column.
    class Stats < ::Decor::Components::Stats
      private

      def root_element_attributes
        {
          element_tag: :div,
          html_options: {
            role: "group",
            "aria-label": "Statistics"
          }
        }
      end

      def view_template
        root_element do
          yield if block_given?
        end
      end

      def root_element_classes
        classes = ["stats"]

        if @responsive
          classes << "stats-vertical lg:stats-horizontal"
        elsif @orientation == :vertical
          classes << "stats-vertical"
        end

        classes << component_shadow_classes if component_shadow_classes
        classes << component_background_classes if component_background_classes

        classes.compact.join(" ")
      end

      def component_shadow_classes
        "shadow" if @shadow
      end

      def component_background_classes
        "bg-base-100" if @background
      end
    end
  end
end
