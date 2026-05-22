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
            # ActionView's text_field tag helper hands `type` through as a
            # String ("text"); coerce so the component's Symbol prop accepts it.
            options["type"] = options["type"].to_sym if options["type"].is_a?(String)
            # See sibling TagWrappers::TextField — don't force `type: :text`;
            # leave it to the component's `prop :type, default: :text` so
            # callers can pass `type: :search` etc.
            merge_options({value: value}, options, TEXT_FIELD_ATTRS, {})
          end
        end
      end
    end
  end
end
