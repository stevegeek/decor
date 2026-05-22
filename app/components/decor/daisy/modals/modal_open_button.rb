# frozen_string_literal: true

module Decor
  module Daisy
    module Modals
      class ModalOpenButton < ::Decor::Components::Modals::ModalOpenButton
        include ::Decor::Daisy::ButtonTemplate
        include ::Decor::Daisy::ButtonClasses

        private

        def root_element_attributes
          {
            element_tag: :button,
            html_options: {
              disabled: @disabled ? "disabled" : nil,
              type: @type
            }
          }
        end
      end
    end
  end
end
