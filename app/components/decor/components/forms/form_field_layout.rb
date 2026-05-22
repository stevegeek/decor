# frozen_string_literal: true

module Decor
  module Components
    module Forms
      class FormFieldLayout < ::Decor::Components::Forms::FormChild
        prop :input_container_classes, _Nilable(String), default: "", reader: :private

        prop :form_field_element, _Nilable(_Any)

        # The HTML ID of the form field.
        prop :field_id, _String(_Predicate("present", &:present?))

        # If the label is not set, no label will be rendered
        prop :label, _Nilable(String)

        # Renders under the label
        prop :description, _Nilable(String)

        # If the field is disabled
        prop :disabled, _Boolean, default: false

        def inline_label(&block)
          @inline_label = block
        end

        def helper_text_section(&block)
          @helper_text_section = block
        end
      end
    end
  end
end
