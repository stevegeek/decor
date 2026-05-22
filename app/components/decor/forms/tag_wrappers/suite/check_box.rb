# frozen_string_literal: true

module Decor
  module Forms
    module TagWrappers
      module Suite
        class CheckBox < ::Decor::Forms::TagWrappers::CheckBox
          CHECKBOX_ATTRS = ::Decor::Suite::Forms::Checkbox.prop_names.map(&:to_s).freeze

          def tag(_type, options)
            return super if options["type"] == "hidden"
            @template_object.render ::Decor::Suite::Forms::Checkbox.new(**check_options(options))
          end

          private

          def check_options(options)
            merge_options(
              {},
              options,
              CHECKBOX_ATTRS,
              {in_group: @options[:multiple] == true, checked: options["checked"] == "checked"}
            )
          end
        end
      end
    end
  end
end
