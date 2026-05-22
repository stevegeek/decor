# frozen_string_literal: true

module Decor
  module Forms
    module TagWrappers
      module Suite
        # Suite-skinned variant of the TextField tag wrapper. Overrides only
        # `tag` to render `Decor::Suite::Forms::TextField` instead of the
        # Daisy default — everything else (option mapping, validation
        # parsing, label fallback) is inherited.
        class TextField < ::Decor::Forms::TagWrappers::TextField
          TEXT_FIELD_ATTRS = ::Decor::Suite::Forms::TextField.prop_names.map(&:to_s).freeze

          def tag(_type, options)
            @template_object.render ::Decor::Suite::Forms::TextField.new(**component_options(options))
          end

          private

          def component_options(options)
            fix_size_option(options)
            options["type"] = options["type"].to_sym if options["type"].is_a?(String)
            merge_options({value: value}, options, TEXT_FIELD_ATTRS, {})
          end
        end
      end
    end
  end
end
