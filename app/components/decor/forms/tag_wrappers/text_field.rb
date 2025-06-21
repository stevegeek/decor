# frozen_string_literal: true

module Decor
  module Forms
    # Extends the default ActionView TextField tag to render a View component that we have defined. Also calls the
    # relevant ValidationParser to map attribute validations from the model or form object to attributes that the View
    # Component understands (and are thus used to setup front end validations)
    module TagWrappers
      class TextField < ActionView::Helpers::Tags::TextField
        include TagWrapper

        TEXT_FIELD_ATTRS = ::Decor::Forms::TextField.prop_names.map(&:to_s).freeze

        def tag(_type, options)
          @template_object.render ::Decor::Forms::TextField.new(**component_options(options))
        end

        def component_options(options)
          merge_options({value: value}, options, TEXT_FIELD_ATTRS, {type: :text})
        end

        def validation_attrs
          ValidationParsers::TextField.call(standard_options[:validations])
        end
      end
    end
  end
end
