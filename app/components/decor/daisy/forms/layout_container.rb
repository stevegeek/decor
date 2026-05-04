# frozen_string_literal: true

module Decor
  module Daisy
    module Forms
      class LayoutContainer < ::Decor::Components::Forms::LayoutContainer
        def view_template
          root_element do
            # form body
            div(class: "space-y-8 sm:space-y-5 divide-y divide-gray-200") do
              yield if block_given?
            end

            # form buttons
            if @buttons.present?
              div(class: "pt-5") do
                div(class: "flex justify-end space-x-3") do
                  render @buttons
                end
              end
            end
          end
        end

        private

        def root_element_classes
          "space-y-8 divide-y divide-gray-200"
        end
      end
    end
  end
end
