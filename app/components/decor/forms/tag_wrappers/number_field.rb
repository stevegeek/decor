# frozen_string_literal: true

module Decor
  module Forms
    module TagWrappers
      class NumberField < ActionView::Helpers::Tags::TextField
        include TagWrapper

        NUMBER_FIELD_ATTRS = ::Decor::Forms::NumberField.prop_names.map(&:to_s).freeze

        def tag(_type, options)
          @template_object.render ::Decor::Forms::NumberField.new(**component_options(options))
        end

        private

        def component_options(options)
          fix_size_option(options)
          merge_options({}, options, NUMBER_FIELD_ATTRS, {type: :number})
        end

        def validation_attrs
          ValidationParsers::NumberField.call(standard_options[:validations])
        end
      end
    end
  end
end
