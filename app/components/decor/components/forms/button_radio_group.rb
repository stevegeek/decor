# frozen_string_literal: true

module Decor
  module Components
    module Forms
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
          # See TextField for `label` rationale.
          values label: -> { @label.to_s }
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
          # NB: Phlex drops nil-valued attributes entirely. The previous form
          # (`attrs[:required] = nil if @required`) emitted nothing on either
          # branch — required radios actually rendered without `required`,
          # silently disabling form-level required validation on this control.
          attrs[:required] = true if @required
          attrs[:disabled] = true if @disabled
          attrs
        end

        def label_html_attributes(idx)
          attrs = {
            for: "#{id}-input-#{idx + 1}"
          }
          attrs[:disabled] = true if @disabled
          attrs
        end

        def selected?(val)
          val == @selected_choice
        end
      end
    end
  end
end
