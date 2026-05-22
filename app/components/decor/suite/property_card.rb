# frozen_string_literal: true

module Decor
  module Suite
    class PropertyCard < ::Decor::Components::PropertyCard
      ACCENT_CLASSES = {
        primary: "decor:border-l-suite-primary-500",
        success: "decor:border-l-suite-success-500",
        warning: "decor:border-l-suite-warning-500",
        danger: "decor:border-l-suite-danger-500",
        neutral: "decor:border-l-gray-400"
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
          "decor:bg-white",
          "decor:border decor:border-suite-hairline",
          "decor:border-l-2",
          ACCENT_CLASSES.fetch(@accent),
          "decor:rounded-suite-card",
          "decor:p-4"
        ].join(" ")
      end

      def render_title_row
        div(class: "decor:flex decor:items-center decor:justify-between decor:mb-3") do
          h3(class: "decor:suite-section-title decor:text-gray-900 decor:m-0") { @title }
          if cta?
            div(class: "decor:shrink-0") { render @cta_block }
          end
        end
      end

      def render_body
        return if @properties.empty?

        property_layout = (@layout == :grid) ? :stack : :row

        if @layout == :grid
          div(class: "decor:grid #{grid_cols_class} decor:gap-y-3 decor:gap-x-6") do
            @properties.each { |p| render_property(p, property_layout) }
          end
        else
          @properties.each { |p| render_property(p, property_layout) }
        end
      end

      def grid_cols_class
        case @columns
        when 2 then "decor:grid-cols-2"
        when 3 then "decor:grid-cols-3"
        when 4 then "decor:grid-cols-4"
        end
      end

      def render_property(p, property_layout)
        if p[:block]
          render ::Decor::Suite::Property.new(
            label: p[:label], meta: p[:meta], icon: p[:icon], layout: property_layout
          ), &p[:block]
        else
          render ::Decor::Suite::Property.new(
            label: p[:label], value: p[:value], meta: p[:meta], icon: p[:icon], layout: property_layout
          )
        end
      end
    end
  end
end
