# frozen_string_literal: true

module Decor
  module Forms
    module TagWrappers
      class EmailField < ActionView::Helpers::Tags::TextField
        include TagWrapper

        def tag(_type, options)
          @template_object.render ::Decor::Forms::TextField.new(**component_options(options))
        end

        def component_options(options)
          merge_options({}, options, TagWrappers::TextField::TEXT_FIELD_ATTRS, {type: :email})
        end

        def validation_attrs
          ValidationParsers::TextField.call(standard_options[:validations])
        end
      end
    end
  end
end
