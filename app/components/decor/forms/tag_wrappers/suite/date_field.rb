# frozen_string_literal: true

module Decor
  module Forms
    module TagWrappers
      module Suite
        # Suite-skinned variant of the DateField tag wrapper. Overrides only
        # `tag` to render `Decor::Suite::Forms::DateCalendar` instead of the
        # Daisy default — option mapping and validation parsing are inherited.
        class DateField < ::Decor::Forms::TagWrappers::DateField
          DATE_FIELD_ATTRS = ::Decor::Suite::Forms::DateCalendar.prop_names.map(&:to_s).freeze

          def tag(_type, options)
            @template_object.render ::Decor::Suite::Forms::DateCalendar.new(**component_options(options))
          end

          private

          def component_options(options)
            fix_size_option(options)
            merge_options({value: value}, options, DATE_FIELD_ATTRS, {type: :date})
          end
        end
      end
    end
  end
end
