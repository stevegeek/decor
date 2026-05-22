# frozen_string_literal: true

module Decor
  module Components
    module Forms
      class Checkbox < ::Decor::Components::Forms::FormField
        include ::Decor::Forms::Concerns::CheckableFormField

        prop :label_position, _Union(:left, :right, :top), default: :right

        stimulus do
          # See TextField for `label` rationale — form_field JS crashes
          # on first blur without it.
          values label: -> { @label.to_s }
          classes invalid_input: "invalid:border-error-dark"
        end

        private

        def input_html_attributes
          attrs = {
            id: "#{id}-control",
            type: "checkbox",
            name: @name,
            value: @value
          }
          attrs[:checked] = true if @checked
          attrs[:required] = true if required_individual?
          attrs[:disabled] = true if @disabled
          attrs
        end
      end
    end
  end
end
