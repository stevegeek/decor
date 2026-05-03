# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for Title. Owns the prop API + defaults.
    # Concrete skins (Daisy, Suite) inherit and provide `view_template`
    # plus their visual-language overrides.
    class Title < ::Decor::PhlexComponent
      no_stimulus_controller

      prop :title, _Nilable(String)
      prop :description, _Nilable(String)
      prop :icon, _Nilable(String)

      default_size :md
    end
  end
end
