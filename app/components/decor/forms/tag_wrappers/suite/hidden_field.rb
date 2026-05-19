# frozen_string_literal: true

module Decor
  module Forms
    module TagWrappers
      module Suite
        # Suite-skinned variant of the HiddenField tag wrapper. Overrides only
        # `tag` to render `Decor::Suite::Forms::HiddenField` instead of the
        # Daisy default — there is no visual chrome on a hidden input, but
        # routing through the Suite component keeps the skin selection
        # consistent across all form helpers.
        class HiddenField < ::Decor::Forms::TagWrappers::HiddenField
          FIELD_ATTRS = ::Decor::Suite::Forms::HiddenField.prop_names.map(&:to_s).freeze

          def tag(_type, options)
            @template_object.render ::Decor::Suite::Forms::HiddenField.new(**component_options(options))
          end

          private

          def component_options(options)
            merge_options({value: value}, options, FIELD_ATTRS, {type: :hidden}).except(:view_context).compact
          end
        end
      end
    end
  end
end
