# frozen_string_literal: true

module Decor
  module Forms
    module TagWrappers
      class CheckBox < ActionView::Helpers::Tags::CheckBox
        include TagWrapper

        CHECKBOX_ATTRS = ::Decor::Forms::Checkbox.prop_names.map(&:to_s).freeze

        def tag(_type, options)
          return super if options["type"] == "hidden"
          component_options = check_options(options)
          @template_object.render ::Decor::Forms::Checkbox.new(**component_options)
        end

        private

        def check_options(options)
          merge_options(
            {},
            options,
            CHECKBOX_ATTRS,
            {in_group: @options[:multiple] == true, checked: options["checked"] == "checked"}
          )
        end

        def validation_attrs
          ValidationParsers::RequiredField.call(standard_options[:validations])
        end
      end
    end
  end
end
