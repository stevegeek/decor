# frozen_string_literal: true

module Decor
  module Forms
    module TagWrappers
      module Suite
        # Suite-skinned variant of the TextArea tag wrapper. Overrides only
        # `content_tag` to render `Decor::Suite::Forms::TextArea` instead of
        # the Daisy default — everything else (option mapping, validation
        # parsing, label fallback) is inherited.
        class TextArea < ::Decor::Forms::TagWrappers::TextArea
          TEXT_FIELD_ATTRS = ::Decor::Suite::Forms::TextArea.prop_names.map(&:to_s).freeze

          def content_tag(_type, value, options)
            @template_object.render ::Decor::Suite::Forms::TextArea.new(**component_options(options))
          end

          private

          def component_options(options)
            fix_size_option(options)
            merge_options({value: value}, options, TEXT_FIELD_ATTRS, {})
          end
        end
      end
    end
  end
end
