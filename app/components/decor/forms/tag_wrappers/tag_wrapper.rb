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

        # For text type fields, we need to change what ActionView has done to the size option as we consider
        # size to be the Decor size, and html_size to be the HTML size (or html_options[:size]).
        def fix_size_option(options)
          if @options[:size].nil? && options.key?("maxlength") # size has been modified by ActionView
            options["size"] = @options[:size]
            options["html_size"] = options["maxlength"]
          elsif @options[:size].present?
            options["size"] = @options[:size]
          end
        end

        def merge_options(initial_component_options, options, option_attrs, override_attrs, move_options_to_html_options: [])
          # tag is called by `render` which is invoked by ActionView. The base ActionView::Helpers::Tags:: classes
          # might be implemented in such a way that the render method adds to the options hash that is then passed to `tag`
          # and adds additional keys. These keys however, for Decor components should be passed as `html_options`
          # (ie they are optional HTML attributes not attributes of the component itself) so we need to do the following:
          if move_options_to_html_options.present?
            options["html_options"] ||= {}
            move_options_to_html_options.each do |option|
              options["html_options"][option] = options[option]
              options.delete(option)
            end
          end

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
