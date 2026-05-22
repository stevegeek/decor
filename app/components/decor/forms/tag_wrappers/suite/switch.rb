# frozen_string_literal: true

module Decor
  module Forms
    module TagWrappers
      module Suite
        class Switch < ::Decor::Forms::TagWrappers::Switch
          SWITCH_ATTRS = ::Decor::Suite::Forms::Switch.prop_names.map(&:to_s).freeze

          def tag(_type, options)
            return super if options["type"] == "hidden"
            @template_object.render ::Decor::Suite::Forms::Switch.new(**check_options(options))
          end

          private

          def check_options(options)
            merge_options({}, options, SWITCH_ATTRS, {checked: options["checked"] == "checked"})
          end
        end
      end
    end
  end
end
