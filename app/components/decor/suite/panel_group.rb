# frozen_string_literal: true

module Decor
  module Suite
    # Suite PanelGroup — a titled muted-chrome container hosting one or more
    # rows of Suite::Panel components. White surface, suite-hairline border,
    # rounded-suite-card corners. Header row uses suite-section-title with an
    # optional description and right-aligned CTA slot. Each panel row is its
    # own section separated by suite-hairline dividers (no alternating fills),
    # with panels laid out via flex-wrap + suite-section-gap.
    class PanelGroup < ::Decor::Components::PanelGroup
      def view_template(&)
        content = capture(&) if block_given?

        root_element do
          if @title.present? || @description.present? || @cta_content
            div(class: "decor:flex decor:items-start decor:justify-between decor:gap-3 decor:px-5 decor:py-4 decor:border-b decor:border-suite-hairline") do
              div(class: "decor:flex-1 decor:min-w-0") do
                if @title.present?
                  h3(class: "decor:suite-section-title decor:text-gray-900 decor:m-0") { plain @title }
                end
                if @description.present?
                  p(class: "decor:suite-description decor:text-gray-500 decor:m-0 decor:mt-1") { plain @description }
                end
              end
              if @cta_content
                div(class: "decor:shrink-0") { render @cta_content }
              end
            end
          end

          @panel_rows.each_with_index do |row_block, idx|
            div(class: section_classes(idx)) do
              div(class: "decor:flex decor:flex-wrap decor:suite-section-gap", &row_block)
            end
          end

          if content.present?
            div(class: "decor:px-5 decor:py-4 decor:suite-description decor:text-gray-500") do
              raw content.html_safe
            end
          end
        end
      end

      def root_element_classes
        "decor:bg-white decor:border decor:border-suite-hairline decor:rounded-suite-card decor:overflow-hidden"
      end

      private

      def section_classes(idx)
        base = "decor:px-5 decor:py-4"
        idx.zero? ? base : "#{base} decor:border-t decor:border-suite-hairline"
      end
    end
  end
end
