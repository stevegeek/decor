# frozen_string_literal: true

module Decor
  module Suite
    # Suite Card — muted-chrome container with optional header / title / footer
    # slots and a body block. Visual identity: white surface, hairline border,
    # rounded-md corners, muted footer bar.
    class Card < ::Decor::Components::Card
      private

      def view_template(&)
        @content = capture(&) if block_given?

        root_element do
          if @card_header
            div(class: "decor:px-5 decor:py-4 decor:border-b decor:border-black/10") do
              render @card_header
            end
          end
          if @card_title
            div(class: "decor:px-5 decor:py-4 decor:border-b decor:border-black/10") do
              p(class: "decor:text-sm decor:font-semibold decor:text-base-content decor:m-0") do
                render @card_title
              end
            end
          end
          if @content.present?
            div(class: "decor:px-5 decor:py-4 decor:text-sm decor:text-base-content/60") do
              raw @content.html_safe
            end
          end
          if @card_footer
            div(class: "decor:px-5 decor:py-3 decor:bg-base-200/40 decor:border-t decor:border-black/10 decor:flex decor:justify-end decor:gap-2") do
              render @card_footer
            end
          end
        end
      end

      def root_element_classes
        "decor:bg-base-100 decor:border decor:border-black/10 decor:rounded-md decor:overflow-hidden"
      end
    end
  end
end
