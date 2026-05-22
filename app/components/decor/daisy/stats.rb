# frozen_string_literal: true

module Decor
  module Daisy
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
        classes = ["decor:d-stats"]

        if @responsive
          classes << "decor:d-stats-vertical decor:lg:d-stats-horizontal"
        elsif @orientation == :vertical
          classes << "decor:d-stats-vertical"
        end

        classes << component_shadow_classes if component_shadow_classes
        classes << component_background_classes if component_background_classes

        classes.compact.join(" ")
      end

      def component_shadow_classes
        "decor:shadow" if @shadow
      end

      def component_background_classes
        "decor:bg-base-100" if @background
      end
    end
  end
end
