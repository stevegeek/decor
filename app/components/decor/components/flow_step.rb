# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for FlowStep. Owns the prop API + defaults + skin-agnostic
    # title-size mapping. Concrete skins (Daisy, Suite) inherit and provide
    # `view_template` plus class-builder overrides for their visual language.
    class FlowStep < ::Decor::PhlexComponent
      no_stimulus_controller

      prop :title, _Nilable(String)
      prop :description, _Nilable(String)

      prop :step, _Nilable(Integer)
      prop :icon, _Nilable(String)

      default_size :md
      default_color :info
      default_style :filled
    end
  end
end
