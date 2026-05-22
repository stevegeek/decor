# frozen_string_literal: true

module Decor
  module Suite
    class SwitchingBox < ::Decor::Components::SwitchingBox
      prop :stack, _Boolean, default: false, predicate: :public

      def html_title?
        @html_title.present?
      end

      def left?
        @left.present?
      end

      private

      def view_template(&)
        @content = capture(&) if block_given?

        root_element do
          div(class: "decor:flex-1 decor:min-w-0") do
            if left?
              render @left
            else
              if html_title?
                div(class: "decor:suite-section-title decor:text-gray-900 decor:mb-0.5") do
                  render @html_title
                end
              elsif @title.present?
                p(class: "decor:suite-section-title decor:text-gray-900 decor:mb-0.5 decor:m-0") { plain(@title) }
              end
              if @description.present?
                p(class: "decor:suite-description decor:text-gray-500 decor:m-0") { plain(@description) }
              end
            end
          end
          if right?
            div(class: "decor:shrink-0 decor:flex decor:gap-2 decor:items-center") { render @right }
          elsif @content.present?
            div(class: "decor:shrink-0 decor:flex decor:gap-2 decor:items-center") do
              raw @content.html_safe
            end
          end
        end
      end

      def root_element_classes
        base = "decor:flex decor:items-center decor:justify-between decor:gap-4 decor:px-5 decor:py-4 decor:bg-white " \
          "decor:transition-colors decor:duration-suite-fast decor:ease-out decor:hover:border-suite-hairline-strong"

        if @stack
          # Stack mode: collapse borders between adjacent items. Middle items
          # keep only the bottom border; first restores top+left+right + top
          # radius; last restores bottom+left+right + bottom radius.
          "#{base} decor:border-b decor:border-suite-hairline decor:border-l-0 decor:border-r-0 decor:border-t-0 decor:rounded-none " \
            "decor:first:border-t decor:first:border-l decor:first:border-r decor:first:rounded-t-suite-card " \
            "decor:last:border-l decor:last:border-r decor:last:rounded-b-suite-card"
        else
          "#{base} decor:border decor:border-suite-hairline decor:rounded-suite-card"
        end
      end
    end
  end
end
