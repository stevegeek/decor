# frozen_string_literal: true

module Decor
  module Suite
    module Forms
      # Suite skin for FormField. Still abstract — concrete input subclasses
      # (TextField, Select, Checkbox, ...) supply `view_template`. Mirrors
      # the Daisy::Forms::FormField placeholder pattern, plus a Suite-wide
      # opt-out for the helper / error caption row.
      #
      # `silent_helper_and_error_text` is the cross-cutting Suite-only prop
      # that every Suite input skin currently redeclares (text_field,
      # text_area, date_calendar, file_upload). Hosted here so future
      # migrations of those concrete skins to inherit from this class can
      # drop the per-skin redeclaration.
      class FormField < ::Decor::Components::Forms::FormField
        # When true, suppress both the helper-text and error-text captions
        # under the control. Validation failure still highlights the
        # control chrome (red border) but renders no caption / icon.
        prop :silent_helper_and_error_text, _Boolean, default: false

        private

        def silent_helper_and_error_text?
          @silent_helper_and_error_text
        end

        # Suite-prefixed stimulus identifier for the root element. Concrete
        # subclasses override this with their own `decor--suite--forms--*`
        # identifier; the base value here keeps the abstract class
        # introspectable and `is_a?`-tested without needing a render.
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
