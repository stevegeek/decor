# frozen_string_literal: true

module Decor
  module Suite
    module Forms
      class LayoutContainer < ::Decor::Components::Forms::LayoutContainer
        def view_template(&)
          @content = capture(&) if block_given?

          root_element do
            raw safe(@content) if @content.present?

            if @buttons.present?
              div(class: "decor:bg-suite-gray-25 decor:px-6 decor:py-4 decor:border-t decor:border-suite-hairline decor:flex decor:justify-end decor:gap-2") do
                render @buttons
              end
            end
          end
        end

        private

        def root_element_classes
          "decor:bg-white decor:border decor:border-suite-hairline decor:rounded-suite-card decor:overflow-hidden"
        end
      end
    end
  end
end
