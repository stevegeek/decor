# frozen_string_literal: true

module Decor
  module Forms
    module TagWrappers
      class TextField < ActionView::Helpers::Tags::TextField
        include TagWrapper

        TEXT_FIELD_ATTRS = ::Decor::Daisy::Forms::TextField.prop_names.map(&:to_s).freeze

        def tag(_type, options)
          @template_object.render ::Decor::Daisy::Forms::TextField.new(**component_options(options))
        end

        def component_options(options)
          fix_size_option(options)
          options["type"] = options["type"].to_sym if options["type"].is_a?(String)
          merge_options({value: value}, options, TEXT_FIELD_ATTRS, {})
        end

        def validation_attrs
          ValidationParsers::TextField.call(standard_options[:validations])
        end
      end
    end
  end
end
