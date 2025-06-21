# frozen_string_literal: true

module Decor
  module Forms
    module TagWrappers
      class ButtonRadioGroup < ActionView::Helpers::Tags::Base
        include TagWrapper

        BUTTON_RADIO_GROUP_ATTRS = ::Decor::Forms::ButtonRadioGroup.prop_names.map(&:to_s).freeze

        def initialize(object_name, method_name, template_object, choices, options, html_options)
          @choices = block_given? ? template_object.capture { yield || "" } : choices
          @choices = @choices.to_a if @choices.is_a?(Range)

          @html_options = html_options

          super(object_name, method_name, template_object, options)
        end

        def render
          options = @options.stringify_keys
          add_default_name_and_id(options)
          component_options = button_radio_group_options(@choices, options)
          @template_object.render ::Decor::Forms::ButtonRadioGroup.new(**component_options)
        end

        private

        def button_radio_group_options(choices, options)
          merge_options({selected_choice: value}, options, BUTTON_RADIO_GROUP_ATTRS, {choices: choices})
        end

        def validation_attrs
          ValidationParsers::RequiredField.call(standard_options[:validations])
        end
      end
    end
  end
end
