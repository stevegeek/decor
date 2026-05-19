# frozen_string_literal: true

module Decor
  module Forms
    module TagWrappers
      module Suite
        # Suite-skinned variant of the ButtonRadioGroup tag wrapper. Overrides
        # only `render` to delegate to `Decor::Suite::Forms::ButtonRadioGroup`
        # instead of the Daisy default — initializer, validation parsing, and
        # label fallback are inherited.
        class ButtonRadioGroup < ::Decor::Forms::TagWrappers::ButtonRadioGroup
          BUTTON_RADIO_GROUP_ATTRS = ::Decor::Suite::Forms::ButtonRadioGroup.prop_names.map(&:to_s).freeze

          def render
            options = @options.stringify_keys
            add_default_name_and_id(options)
            component_options = button_radio_group_options(@choices, options)
            @template_object.render ::Decor::Suite::Forms::ButtonRadioGroup.new(**component_options)
          end

          private

          def button_radio_group_options(choices, options)
            merge_options({selected_choice: value}, options, BUTTON_RADIO_GROUP_ATTRS, {choices: choices})
          end
        end
      end
    end
  end
end
