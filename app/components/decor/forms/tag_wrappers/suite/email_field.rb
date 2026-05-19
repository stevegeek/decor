# frozen_string_literal: true

module Decor
  module Forms
    module TagWrappers
      module Suite
        # Suite-skinned variant of the EmailField tag wrapper. Overrides only
        # `tag` to render `Decor::Suite::Forms::TextField` (with `type: :email`)
        # instead of the Daisy default.
        class EmailField < ::Decor::Forms::TagWrappers::EmailField
          TEXT_FIELD_ATTRS = ::Decor::Suite::Forms::TextField.prop_names.map(&:to_s).freeze

          def tag(_type, options)
            @template_object.render ::Decor::Suite::Forms::TextField.new(**component_options(options))
          end

          private

          def component_options(options)
            fix_size_option(options)
            merge_options({}, options, TEXT_FIELD_ATTRS, {type: :email})
          end
        end
      end
    end
  end
end
