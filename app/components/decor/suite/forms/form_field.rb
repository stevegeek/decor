# frozen_string_literal: true

module Decor
  module Suite
    module Forms
      class FormField < ::Decor::Components::Forms::FormField
        prop :silent_helper_and_error_text, _Boolean, default: false

        private

        def silent_helper_and_error_text?
          @silent_helper_and_error_text
        end

        def root_element_classes
          [
            "decor--suite--forms--form-field",
            "decor:w-full",
            disabled? ? "decor:disabled" : nil,
            *grid_span_class
          ].compact
        end
      end
    end
  end
end
