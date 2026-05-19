# frozen_string_literal: true

module Decor
  module Suite
    module Forms
      # Suite HiddenField — emits a single `<input type="hidden">` so a form
      # picks up the value. No visual chrome: no label, helper text, error
      # text, or container styling. Identical in shape to the Daisy peer
      # because there is nothing skin-specific to style.
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

        private

        def root_element_classes
          [
            "decor--suite--forms--hidden-field",
            *grid_span_class
          ].compact.join(" ")
        end
      end
    end
  end
end
