# frozen_string_literal: true

module Decor
  module Forms
    module TagWrappers
      class HiddenField < ActionView::Helpers::Tags::TextField
        include TagWrapper

        FIELD_ATTRS = ::Decor::Forms::HiddenField.prop_names.map(&:to_s).freeze

        def tag(_type, options)
          @template_object.render ::Decor::Forms::HiddenField.new(**component_options(options))
        end

        def component_options(options)
          merge_options({value: value}, options, FIELD_ATTRS, {type: :hidden})
        end

        def validation_attrs
          {}
        end
      end
    end
  end
end
