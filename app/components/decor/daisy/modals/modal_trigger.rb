# frozen_string_literal: true

module Decor
  module Daisy
    module Modals
      class ModalTrigger < ::Decor::Components::Modals::ModalTrigger
        def view_template(&)
          @content = capture(&) if block_given?
          root_element do
            raw @content if @content.present?
          end
        end

        private

        def root_element_attributes
          {
            element_tag: :span,
            html_options: {
              role: "button",
              tabindex: "0"
            }
          }
        end

        def root_element_classes
          "decor:inline-block decor:cursor-pointer"
        end
      end
    end
  end
end
