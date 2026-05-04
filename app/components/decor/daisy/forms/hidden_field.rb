# frozen_string_literal: true

module Decor
  module Daisy
    module Forms
      class HiddenField < ::Decor::Components::Forms::HiddenField
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
      end
    end
  end
end
