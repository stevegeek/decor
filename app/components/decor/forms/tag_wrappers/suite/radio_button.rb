# frozen_string_literal: true

module Decor
  module Forms
    module TagWrappers
      module Suite
        class RadioButton < ::Decor::Forms::TagWrappers::RadioButton
          RADIO_ATTRS = ::Decor::Suite::Forms::Radio.prop_names.map(&:to_s).freeze

          def tag(_type, options)
            return super if options["type"] == "hidden"
            @template_object.render ::Decor::Suite::Forms::Radio.new(**radio_options(options))
          end

          private

          def radio_options(options)
            merge_options({}, options, RADIO_ATTRS, {checked: options["value"] == value})
          end
        end
      end
    end
  end
end
