# frozen_string_literal: true

module Decor
  module Forms
    module TagWrappers
      class DateField < ActionView::Helpers::Tags::TextField
        include TagWrapper

        DATE_FIELD_ATTRS = ::Decor::Forms::DateCalendar.prop_names.map(&:to_s).freeze

        def tag(_type, options)
          @template_object.render ::Decor::Forms::DateCalendar.new(**component_options(options))
        end

        def component_options(options)
          fix_size_option(options)
          merge_options({value: value}, options, DATE_FIELD_ATTRS, {type: :date})
        end

        def validation_attrs
          ValidationParsers::TextField.call(standard_options[:validations])
        end
      end
    end
  end
end
