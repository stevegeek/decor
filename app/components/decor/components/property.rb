# frozen_string_literal: true

module Decor
  module Components
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
