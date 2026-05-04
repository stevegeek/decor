# frozen_string_literal: true

module Decor
  module Daisy
    module Forms
      # Concrete daisy skin for FormChild. FormChild is abstract (no
      # `view_template`) and has no skin-specific behaviour of its own — this
      # subclass exists for consistency with the Components/Daisy split.
      # Subclasses (FormFieldLayout, FormField) override view_template and
      # supply their own daisy-specific class strings.
      class FormChild < ::Decor::Components::Forms::FormChild
      end
    end
  end
end
