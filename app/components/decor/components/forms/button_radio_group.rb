# frozen_string_literal: true

module Decor
  module Components
    module Forms
      # Abstract base for ButtonRadioGroup. Owns the prop API + defaults +
      # stimulus block + the input-attribute builders + selection predicate.
      # Concrete skins (Daisy, Suite) inherit and provide `view_template`
      # plus the daisy-specific class builders.
      class ButtonRadioGroup < ::Decor::Components::Forms::FormField
        prop :choices, Array
        prop :selected_choice, _Nilable(String)

        # Button groups mostly don't have labels
        prop :show_label, _Boolean, default: false

        # Use unified prop system
        default_size :md
        default_color :primary
        default_style :outlined

        redefine_styles :outlined, :filled, :ghost, :link

        stimulus do
          classes valid_label: -> { @disabled ? "text-disabled" : "text-gray-900" },
            invalid_label: "text-error-dark",
            valid_helper_text: -> { @disabled ? "text-disabled" : "text-gray-500" },
            invalid_helper_text: "text-error"
        end

        private

        def input_html_attributes(idx, value)
          attrs = {
            id: "#{id}-input-#{idx + 1}",
            type: "radio",
            name: @name,
            value: value,
            class: "decor:sr-only"
          }
          attrs[:checked] = true if @selected_choice == value
          attrs[:required] = nil if @required
          attrs[:disabled] = nil if @disabled
          attrs
        end

        def label_html_attributes(idx)
          attrs = {
            for: "#{id}-input-#{idx + 1}"
          }
          attrs[:disabled] = nil if @disabled
          attrs
        end

        def selected?(val)
          val == @selected_choice
        end
      end
    end
  end
end
