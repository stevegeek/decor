# frozen_string_literal: true

module Decor
  module Forms
    module TagWrappers
      class PasswordField < ActionView::Helpers::Tags::TextField
        include TagWrapper

        def tag(_type, options)
          @template_object.render ::Decor::Forms::TextField.new(**component_options(options))
        end

        # tag is called by `render` which is invoked by ActionView. It maps maxlength to size.
        def component_options(options)
          fix_size_option(options)
          merge_options({}, options, TagWrappers::TextField::TEXT_FIELD_ATTRS, {type: :password})
        end

        def validation_attrs
          ValidationParsers::TextField.call(standard_options[:validations])
        end
      end
    end
  end
end
