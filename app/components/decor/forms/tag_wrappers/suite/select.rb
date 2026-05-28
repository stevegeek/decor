# frozen_string_literal: true

module Decor
  module Forms
    module TagWrappers
      module Suite
        class Select < ::Decor::Forms::TagWrappers::Select
          SELECT_ATTRS = ::Decor::Suite::Forms::Select.prop_names.map(&:to_s).freeze

          def select_content_tag(option_tags, options, html_options)
            options = options.merge(html_options: html_options).stringify_keys
            add_default_name_and_id(options)
            # Rails' `select(method, choices, options, html_options)` passes
            # `multiple` in html_options, but it's a Decor component prop — lift
            # it so the component renders `<select multiple>` with a `name[]`.
            options["multiple"] = true if html_options[:multiple] || html_options["multiple"]
            @template_object.render ::Decor::Suite::Forms::Select.new(**select_options(option_tags, options))
          end

          private

          def select_options(option_tags, options)
            merge_options({selected_option: value}, options, SELECT_ATTRS, {options_array: option_tags})
          end
        end
      end
    end
  end
end
