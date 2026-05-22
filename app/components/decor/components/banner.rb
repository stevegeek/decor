# frozen_string_literal: true

module Decor
  module Components
    class Banner < ::Decor::PhlexComponent
      no_stimulus_controller

      prop :icon, _Nilable(String)
      prop :link, _Nilable(_String(&:present?))
      prop :centered, _Boolean, default: false

      default_color :primary

      def call_to_action(&block)
        @call_to_action = block
      end
    end
  end
end
