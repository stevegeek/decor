# frozen_string_literal: true

module Decor
  module Forms
    module TagWrappers
      class RadioButton < ActionView::Helpers::Tags::RadioButton
        include TagWrapper

        RADIO_ATTRS = ::Decor::Forms::Radio.prop_names.map(&:to_s).freeze

        def tag(_type, options)
          return super if options["type"] == "hidden"
          component_options = radio_options(options)
          @template_object.render ::Decor::Forms::Radio.new(**component_options)
        end

        private

        def radio_options(options)
          merge_options({}, options, RADIO_ATTRS, {checked: options["value"] == value})
        end

        def validation_attrs
          ValidationParsers::RequiredField.call(standard_options[:validations])
        end
      end
    end
  end
end
