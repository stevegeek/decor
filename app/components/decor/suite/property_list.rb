# frozen_string_literal: true

module Decor
  module Suite
    class PropertyList < ::Decor::Components::PropertyList
      def view_template(&)
        capture(&) if block_given?

        root_element do
          div(class: "decor:bg-white decor:border decor:border-suite-hairline decor:rounded-suite-card decor:p-4") do
            if @title || cta?
              div(class: "decor:flex decor:items-center decor:justify-between decor:mb-3") do
                if @title
                  h3(class: "decor:suite-section-title decor:text-gray-900 decor:m-0") { @title }
                else
                  span
                end
                if cta?
                  div(class: "decor:shrink-0") { render @cta_block }
                end
              end
            end

            @sections.each_with_index do |section, idx|
              div(class: section_classes(idx)) do
                if section[:kicker]
                  div(class: "decor:mb-2") do
                    span(class: "decor:suite-caption decor:text-gray-500") { section[:kicker] }
                  end
                end
                if grid?
                  div(class: section_inner_classes) { render section[:block] }
                else
                  render section[:block]
                end
              end
            end
          end
        end
      end

      private

      def section_classes(idx)
        idx.zero? ? nil : "decor:mt-3 decor:pt-3 decor:border-t decor:border-suite-hairline"
      end

      def section_inner_classes
        "decor:grid decor:grid-cols-#{@columns} decor:gap-y-3 decor:gap-x-6"
      end
    end
  end
end
