# frozen_string_literal: true

module Decor
  module Daisy
    class PropertyStrip < ::Decor::Components::PropertyStrip
      def view_template(&)
        capture(&) if block_given?

        root_element do
          if @title
            h2(class: "decor:text-lg decor:font-semibold decor:m-0") { @title }
          end
          if @subtitle
            p(class: "decor:text-xs decor:text-base-content/60 decor:mt-1 decor:mb-4") { @subtitle }
          end

          if @properties.any?
            div(class: "decor:border-y decor:border-base-300 decor:py-4", style: grid_style) do
              @properties.each { |p| render_property(p) }
            end
          end
        end
      end

      private

      def grid_style
        "display: grid; grid-template-columns: repeat(auto-fit, minmax(#{@min_column_width}px, 1fr)); gap: 16px 24px;"
      end

      def render_property(p)
        if p[:block]
          render ::Decor::Daisy::Property.new(label: p[:label], meta: p[:meta], icon: p[:icon], layout: :stack), &p[:block]
        else
          render ::Decor::Daisy::Property.new(label: p[:label], value: p[:value], meta: p[:meta], icon: p[:icon], layout: :stack)
        end
      end
    end
  end
end
