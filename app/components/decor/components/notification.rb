# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for Notification. Owns the ActionButton value-object,
    # prop API, defaults, and slot helpers. Concrete skins (Daisy, Suite)
    # inherit and provide `view_template` plus class-builder overrides.
    class Notification < ::Decor::PhlexComponent
      no_stimulus_controller

      class ActionButton < ::Literal::Data
        # ActionButton is used to define an action button within a notification.
        # It can be a link or a button, and can be styled as primary or secondary.
        # The `href` attribute is optional; if provided, it will render as a link.
        # If `action_name` is provided, it will be used for Stimulus actions.
        prop :label, String
        prop :href, _Nilable(String)
        prop :action_name, _Nilable(String)
        prop :primary, _Boolean, default: false, predicate: :public
        prop :color, _Nilable(Symbol)
        prop :style, _Nilable(Symbol)

        def text_classes
          primary? ? "font-medium text-primary hover:text-primary-focus" : "text-base-content hover:text-base-content/70"
        end

        attr_reader :href
      end

      prop :title, String
      prop :description, _Nilable(String)
      prop :icon, _Nilable(String)
      prop :action_buttons, _Array(ActionButton), default: -> { [] }

      default_color :info

      def avatar(&block)
        @avatar = block
      end
    end
  end
end
