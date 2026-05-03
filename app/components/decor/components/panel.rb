# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for Panel. Owns the prop API + defaults.
    # Concrete skins (Daisy, Suite) inherit and provide `view_template`
    # plus class-builder overrides for their visual language.
    class Panel < ::Decor::PhlexComponent
      include ::Decor::Concerns::StyleColorClasses

      no_stimulus_controller

      prop :title, String
      prop :icon, _Nilable(String)

      default_size :md
      default_color :base
      default_style :filled
    end
  end
end
