# frozen_string_literal: true

module Decor
  module Components
    module Forms
      class HiddenField < ::Decor::Components::Forms::FormField
        private

        def root_element_attributes
          {
            html_options: {hidden: "hidden"}
          }
        end

        def html_attributes
          attrs = {
            type: "hidden",
            hidden: "hidden",
            autocomplete: "off",
            name: @name,
            value: @value,
            id: id
          }
          attrs[:disabled] = true if @disabled
          attrs
        end
      end
    end
  end
end
