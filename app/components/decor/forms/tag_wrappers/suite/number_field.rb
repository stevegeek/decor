# frozen_string_literal: true

module Decor
  module Forms
    module TagWrappers
      module Suite
        class NumberField < ::Decor::Forms::TagWrappers::NumberField
          NUMBER_FIELD_ATTRS = ::Decor::Suite::Forms::NumberField.prop_names.map(&:to_s).freeze

          def tag(_type, options)
            @template_object.render ::Decor::Suite::Forms::NumberField.new(**component_options(options))
          end

          private

          def component_options(options)
            fix_size_option(options)
            merge_options({}, options, NUMBER_FIELD_ATTRS, {type: :number})
          end
        end
      end
    end
  end
end
