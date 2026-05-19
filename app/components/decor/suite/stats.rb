# frozen_string_literal: true

module Decor
  module Suite
    # Suite Stats — chrome container for a row (or column) of Stat tiles.
    # Visual identity: white surface, suite-hairline border,
    # rounded-suite-card corners; children are separated by suite-hairline
    # dividers (vertical between horizontal tiles, horizontal between
    # vertical/stacked tiles). Compose `Decor::Suite::Stat` children
    # inside the block via `el.render(...)`.
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

      def view_template(&)
        root_element do
          yield if block_given?
        end
      end

      def root_element_classes
        classes = ["decor:bg-white", "decor:border", "decor:border-suite-hairline", "decor:rounded-suite-card", "decor:overflow-hidden"]
        classes.concat(layout_classes)
        classes.join(" ")
      end

      def layout_classes
        if @responsive
          [
            "decor:flex", "decor:flex-col", "decor:divide-y", "decor:divide-suite-hairline",
            "decor:lg:flex-row", "decor:lg:divide-y-0", "decor:lg:divide-x"
          ]
        elsif @orientation == :vertical
          ["decor:flex", "decor:flex-col", "decor:divide-y", "decor:divide-suite-hairline"]
        else
          ["decor:flex", "decor:flex-row", "decor:divide-x", "decor:divide-suite-hairline"]
        end
      end
    end
  end
end
