# frozen_string_literal: true

module Decor
  module Forms
    module TagWrappers
      class Select < ActionView::Helpers::Tags::Select
        include TagWrapper

        SELECT_ATTRS = ::Decor::Forms::Select.prop_names.map(&:to_s).freeze

        def grouped_options_for_select(_grouped_options, _selected_key = nil, _options = {})
          @choices
        end

        def options_for_select(_container, _selected = nil)
          @choices
        end

        def select_content_tag(option_tags, options, html_options)
          options = options.merge(html_options: html_options).stringify_keys
          add_default_name_and_id(options)
          component_options = select_options(option_tags, options)
          @template_object.render ::Decor::Forms::Select.new(**component_options)
        end

        private

        def select_options(option_tags, options)
          merge_options({selected_option: value}, options, SELECT_ATTRS, {options_array: option_tags})
        end

        def validation_attrs
          ValidationParsers::RequiredField.call(standard_options[:validations])
        end
      end
    end
  end
end
