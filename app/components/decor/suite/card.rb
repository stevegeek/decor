# frozen_string_literal: true

module Decor
  module Suite
    class Card < ::Decor::Components::Card
      private

      def view_template(&)
        @content = capture(&) if block_given?

        root_element do
          if @card_header
            div(class: "decor:px-5 decor:py-4 decor:border-b decor:border-suite-hairline") do
              render @card_header
            end
          end
          if @card_title
            div(class: "decor:px-5 decor:py-4 decor:border-b decor:border-suite-hairline") do
              p(class: "decor:suite-dense-body decor:font-semibold decor:text-gray-900 decor:m-0") do
                render @card_title
              end
            end
          end
          if @content.present?
            div(class: "decor:px-5 decor:py-4 decor:suite-description decor:text-gray-500") do
              raw @content.html_safe
            end
          end
          if @card_footer
            div(class: "decor:px-5 decor:py-3 decor:bg-suite-gray-25 decor:border-t decor:border-suite-hairline decor:flex decor:justify-end decor:gap-2") do
              render @card_footer
            end
          end
        end
      end

      def root_element_classes
        "decor:bg-white decor:border decor:border-suite-hairline decor:rounded-suite-card decor:overflow-hidden"
      end
    end
  end
end
