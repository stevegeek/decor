# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for Property — a single label/value pair with optional
    # icon and meta caption. Used standalone or inside PropertyStrip.
    # Concrete skins (Daisy, Suite) inherit and provide `view_template`
    # plus class-builder overrides for their visual language.
    class Property < ::Decor::PhlexComponent
      no_stimulus_controller

      prop :label, String
      prop :value, _Nilable(_Any)
      prop :meta, _Nilable(String)
      prop :icon, _Nilable(String)
      prop :layout, _Union(:stack, :row), default: :stack
    end
  end
end
