# frozen_string_literal: true

module Decor
  module Forms
    module TagWrappers
      module TagWrapper
        def standard_options
          @standard_options ||=
            {
              error_messages: object ? error_message.to_a : [],
              object_name: @object_name,
              method_name: @method_name,
              view_context: @template_object,
              object: object
            }.merge(object ? {validations: ValidationMapping.call(object, @method_name)} : {})
        end

        def merge_options(initial_component_options, options, option_attrs, override_attrs)
          base = standard_options
            .clone
            .merge(initial_component_options)
            .merge(validation_attrs)
            .merge(options.slice(*option_attrs).symbolize_keys)
            .merge(override_attrs)
          if base[:label].blank? && options["show_label"] != false
            base[:label] = @method_name&.humanize
          elsif options["show_label"] == false
            base[:label] = nil
          end
          # Filter out view_context and other non-component options
          base.except(:view_context).compact
        end

        def validation_attrs
          {}
        end
      end
    end
  end
end
