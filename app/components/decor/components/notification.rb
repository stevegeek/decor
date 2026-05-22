# frozen_string_literal: true

module Decor
  module Components
    class Notification < ::Decor::PhlexComponent
      no_stimulus_controller

      class ActionButton < ::Literal::Data
        prop :label, String
        prop :href, _Nilable(String)
        prop :action_name, _Nilable(String)
        prop :primary, _Boolean, default: false, predicate: :public
        prop :color, _Nilable(Symbol)
        prop :style, _Nilable(Symbol)

        def text_classes
          primary? ? "decor:font-medium decor:text-primary decor:hover:text-primary-focus" : "decor:text-base-content decor:hover:text-base-content/70"
        end

        attr_reader :href
      end

      prop :title, _Nilable(String)
      prop :description, _Nilable(String)
      prop :body, _Nilable(String)
      prop :icon, _Nilable(String)
      prop :action_buttons, _Array(ActionButton), default: -> { [] }

      # `actions` hashes may carry :text, :href, :style (:primary|:ghost), :event_name.
      prop :actions, _Array(_Hash(Symbol, _Any)), default: -> { [] }
      prop :destination, _Nilable(_Hash(Symbol, String))
      prop :show_progress, _Boolean, default: false
      prop :sticky, _Boolean, default: false

      default_color :info

      def avatar(&block)
        @avatar = block
      end
    end
  end
end
