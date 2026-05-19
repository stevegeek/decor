# frozen_string_literal: true

module Decor
  module Components
    module Forms
      # Abstract base for Radio. Owns the prop API + stimulus block +
      # html_attributes builder + the CheckableFormField concern. Concrete
      # skins (Daisy, Suite) inherit and provide `view_template` plus the
      # daisy-specific class builders.
      class Radio < ::Decor::Components::Forms::FormField
        include ::Decor::Forms::Concerns::CheckableFormField

        prop :label_position, _Union(:left, :right), default: :right

        stimulus do
          # See TextField for `label` rationale.
          values label: -> { @label.to_s }
          classes invalid_input: "invalid:border-error-dark"
        end

        private

        def html_attributes
          attrs = {
            id: "#{id}-control",
            type: "radio",
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
