# frozen_string_literal: true

module Decor
  module Forms
    module TagWrappers
      class TextArea < ActionView::Helpers::Tags::TextArea
        include TagWrapper

        TEXT_FIELD_ATTRS = ::Decor::Forms::TextArea.prop_names.map(&:to_s).freeze

        def content_tag(_type, value, options)
          @template_object.render ::Decor::Forms::TextArea.new(**component_options(options))
        end

        def component_options(options)
          merge_options({value: value}, options, TEXT_FIELD_ATTRS, {})
        end

        def validation_attrs
          ValidationParsers::TextField.call(standard_options[:validations])
        end
      end
    end
  end
end
