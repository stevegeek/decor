# frozen_string_literal: true

module Decor
  module Daisy
    module Forms
      class LayoutContainer < ::Decor::Components::Forms::LayoutContainer
        def view_template
          root_element do
            # form body
            div(class: "decor:space-y-8 decor:sm:space-y-5 decor:divide-y decor:divide-gray-200") do
              yield if block_given?
            end

            # form buttons
            if @buttons.present?
              div(class: "decor:pt-5") do
                div(class: "decor:flex decor:justify-end decor:space-x-3") do
                  render @buttons
                end
              end
            end
          end
        end

        private

        def root_element_classes
          "decor:space-y-8 decor:divide-y decor:divide-gray-200"
        end
      end
    end
  end
end
