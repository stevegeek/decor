# frozen_string_literal: true

module Decor
  module Forms
    class HiddenField < FormField
      def view_template
        root_element do |el|
          input(
            data_controller: form_control_controller,
            class: input_classes,
            **html_attributes,
            data: input_data_attributes(el)
          )
        end
      end

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
        attrs[:disabled] = nil if @disabled
        attrs
      end
    end
  end
end
