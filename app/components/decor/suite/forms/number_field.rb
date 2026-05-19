# frozen_string_literal: true

module Decor
  module Suite
    module Forms
      # Suite NumberField — text-shaped input narrowed for numeric entry.
      # Inherits the full Suite TextField chrome (shell, boxed add-ons, focus
      # ring, density tokens, helper / error caption) and adds:
      #   - default `type: :number`
      #   - default `numerical: true` (validation hook)
      #   - default `pattern` that gates [0-9]* (or [0-9-.]* when float allowed)
      #   - right-aligned, tabular-num input for column-friendly numeric values
      class NumberField < ::Decor::Suite::Forms::TextField
        # Re-declare number-specific defaults on top of the Suite TextField
        # chrome. Mirrors Decor::Components::Forms::NumberField (which sits
        # above Components::TextField rather than above the Suite skin).
        prop :type, Symbol, default: :number
        prop :numerical, _Boolean, default: true
        prop :allow_float_input, _Boolean, default: false, reader: :public

        # iOS surfaces a numbers-only soft keyboard for pattern="[0-9]*"; widen
        # to include `.` and `-` when callers want floats. Resolved at render
        # time via TextField#resolved_pattern so the Proc wins over Literal's
        # prop-declaration-order init of @allow_float_input.
        prop :pattern, _Nilable(_Any), default: -> {
          ->(instance) { instance.allow_float_input? ? "[0-9-.]*" : "[0-9]*" }
        }

        def allow_float_input?
          @allow_float_input
        end

        private

        def root_element_classes
          [
            "decor--suite--forms--number-field",
            "decor:w-full",
            disabled? ? "decor:disabled" : nil,
            *grid_span_class
          ].compact.join(" ")
        end

        # Right-align + tabular figures keep numeric values lined up in tight
        # admin tables. Layer on top of the standard Suite input chrome.
        def input_classes_str
          "#{super} decor:text-right decor:tabular-nums"
        end
      end
    end
  end
end
