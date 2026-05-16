# frozen_string_literal: true

module Decor
  module Daisy
    # PropertyCard renders a card-shaped grouping of label/value pairs with
    # an optional left accent edge, title row, optional CTA slot, and a
    # rows-or-grid body of properties. Daisy chrome: base-100 surface,
    # base-300 hairline, rounded-box corners.
    class PropertyCard < ::Decor::Components::PropertyCard
      ACCENT_CLASSES = {
        primary: "decor:border-l-primary",
        success: "decor:border-l-success",
        warning: "decor:border-l-warning",
        danger: "decor:border-l-error",
        neutral: "decor:border-l-base-300"
      }.freeze

      def view_template(&)
        capture(&) if block_given?

        root_element do
          div(class: surface_classes) do
            render_title_row
            render_body
          end
        end
      end

      private

      def surface_classes
        [
          "decor:bg-base-100",
          "decor:border decor:border-base-300",
          "decor:border-l-2",
          ACCENT_CLASSES.fetch(@accent),
          "decor:rounded-box",
          "decor:p-4"
        ].join(" ")
      end

      def render_title_row
        div(class: "decor:flex decor:items-center decor:justify-between decor:mb-3") do
          h3(class: "decor:text-base decor:font-semibold decor:m-0") { @title }
          if cta?
            div(class: "decor:shrink-0") { render @cta_block }
          end
        end
      end

      def render_body
        return if @properties.empty?

        property_layout = (@layout == :grid) ? :stack : :row

        if @layout == :grid
          div(class: "decor:grid decor:#{grid_cols_class} decor:gap-y-3 decor:gap-x-6") do
            @properties.each { |p| render_property(p, property_layout) }
          end
        else
          @properties.each { |p| render_property(p, property_layout) }
        end
      end

      def grid_cols_class
        case @columns
        when 2 then "grid-cols-2"
        when 3 then "grid-cols-3"
        when 4 then "grid-cols-4"
        end
      end

      def render_property(p, property_layout)
        if p[:block]
          render ::Decor::Daisy::Property.new(
            label: p[:label], meta: p[:meta], icon: p[:icon], layout: property_layout
          ), &p[:block]
        else
          render ::Decor::Daisy::Property.new(
            label: p[:label], value: p[:value], meta: p[:meta], icon: p[:icon], layout: property_layout
          )
        end
      end
    end
  end
end
