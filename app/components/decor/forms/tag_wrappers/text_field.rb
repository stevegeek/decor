# frozen_string_literal: true

module Decor
  module Forms
    # Extends the default ActionView TextField tag to render a View component that we have defined. Also calls the
    # relevant ValidationParser to map attribute validations from the model or form object to attributes that the View
    # Component understands (and are thus used to setup front end validations)
    module TagWrappers
      class TextField < ActionView::Helpers::Tags::TextField
        include TagWrapper

        TEXT_FIELD_ATTRS = ::Decor::Daisy::Forms::TextField.prop_names.map(&:to_s).freeze

        def tag(_type, options)
          @template_object.render ::Decor::Daisy::Forms::TextField.new(**component_options(options))
        end

        def component_options(options)
          fix_size_option(options)
          # ActionView's text_field tag helper hands `type` through as a String
          # ("text"), but the component prop is `_Union(Symbol, …)` — coerce.
          options["type"] = options["type"].to_sym if options["type"].is_a?(String)
          # NB: do not pass `{type: :text}` as an override — the component's
          # `prop :type, default: :text` already supplies the default, and
          # forcing it here would prevent callers from passing `type: :search`
          # or any other valid input type.
          merge_options({value: value}, options, TEXT_FIELD_ATTRS, {})
        end

        def validation_attrs
          ValidationParsers::TextField.call(standard_options[:validations])
        end
      end
    end
  end
end
