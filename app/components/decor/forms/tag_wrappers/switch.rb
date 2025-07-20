# frozen_string_literal: true

module Decor
  module Forms
    module TagWrappers
      class Switch < ActionView::Helpers::Tags::CheckBox
        include TagWrapper

        SWITCH_ATTRS = ::Decor::Forms::Switch.prop_names.map(&:to_s).freeze

        def tag(_type, options)
          return super if options["type"] == "hidden"
          component_options = check_options(options)
          @template_object.render ::Decor::Forms::Switch.new(**component_options)
        end

        private

        def check_options(options)
          merge_options({}, options, SWITCH_ATTRS, {checked: options["checked"] == "checked"})
        end

        def validation_attrs
          ValidationParsers::RequiredField.call(standard_options[:validations])
        end
      end
    end
  end
end
