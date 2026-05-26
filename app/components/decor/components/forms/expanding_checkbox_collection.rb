# frozen_string_literal: true

module Decor
  module Components
    module Forms
      class ExpandingCheckboxCollection < ::Decor::Components::Forms::FormField
        prop :size, _Nilable(Integer)
        prop :hide_after_showing, _Nilable(Integer)

        # Use unified color system for button styling
        default_color :primary

        # ExpandingCheckboxCollection uses domain-specific styles for layout
        default_style :default
        redefine_styles :default, :joined

        stimulus do
          # Declare outlets for BOTH skin's Checkbox identifiers — the
          # collection's controller (currently only Daisy ships one) needs
          # to discover the actual rendered child checkbox controllers, and
          # Suite renders `decor--suite--forms--checkbox` while Daisy renders
          # `decor--daisy--forms--checkbox`. One extra `data-...-outlet`
          # attribute on the root is cheap and avoids a per-skin override.
          outlets({
            ::Decor::Daisy::Forms::Checkbox => nil,
            ::Decor::Suite::Forms::Checkbox => nil
          })
          values label: "collection", required: -> { @required }
          classes(
            valid_label: -> { @disabled ? "text-disabled" : "text-gray-900" },
            invalid_label: "text-error",
            valid_helper_text: -> { @disabled ? "text-disabled" : "text-gray-500" },
            invalid_helper_text: "text-error"
          )
        end

        def checkboxes(&block)
          @checkboxes = capture(&block) if block_given?
        end
      end
    end
  end
end
