# frozen_string_literal: true

module Decor
  module Components
    class Title < ::Decor::PhlexComponent
      no_stimulus_controller

      prop :title, _Nilable(String)
      prop :description, _Nilable(String)
      prop :icon, _Nilable(String)

      default_size :md
    end
  end
end
