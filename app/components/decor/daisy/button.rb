# frozen_string_literal: true

module Decor
  module Daisy
    class Button < ::Decor::Components::Button
      include ::Decor::Daisy::ButtonTemplate
      include ::Decor::Daisy::ButtonClasses

      private

      def root_element_attributes
        {
          element_tag: :button,
          html_options: {
            disabled: @disabled ? "disabled" : nil
          }
        }
      end
    end
  end
end
