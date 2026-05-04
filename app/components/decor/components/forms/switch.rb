# frozen_string_literal: true

module Decor
  module Components
    module Forms
      # Abstract base for Switch. Owns the prop API + stimulus block +
      # html_attributes builder + the CheckableFormField concern. Concrete
      # skins (Daisy, Suite) inherit and provide `view_template` plus the
      # daisy-specific class builders.
      #
      # The paired Stimulus controller lives at
      # app/javascript/controllers/decor/daisy/forms/switch_controller.js.
      class Switch < ::Decor::Components::Forms::FormField
        include ::Decor::Forms::Concerns::CheckableFormField

        prop :label_position, _Union(:top, :left, :right, :inline, :inside), default: :right

        prop :submit_on_change, _Boolean, default: false
        prop :confirm_on_submit, _Nilable(_String(&:present?))
        prop :confirm_on_submit_yes, _Nilable(_String(&:present?)), default: "Yes, continue"
        prop :confirm_on_submit_no, _Nilable(_String(&:present?)), default: "Cancel"

        stimulus do
          actions [:change, :handle_change]
          values_from_props :label,
            :submit_on_change
          values confirm_on_submit: -> { @confirm_on_submit.present? ? @confirm_on_submit : nil },
            confirm_on_submit_yes: -> { @confirm_on_submit.present? ? @confirm_on_submit_yes : nil },
            confirm_on_submit_no: -> { @confirm_on_submit.present? ? @confirm_on_submit_no : nil }
        end

        private

        def html_attributes
          attrs = {
            role: "switch",
            id: "#{id}-control",
            name: @name,
            value: @value
          }
          attrs[:checked] = true if @checked
          attrs[:required] = true if required_individual?
          attrs[:disabled] = true if @disabled
          attrs
        end

        def confirm_on_submit?
          @confirm_on_submit.present?
        end
      end
    end
  end
end
