# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for Banner. Owns the prop API + defaults + slot helpers.
    # Concrete skins (Daisy, Suite) inherit and provide `view_template`
    # plus class-builder overrides for their visual language.
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
