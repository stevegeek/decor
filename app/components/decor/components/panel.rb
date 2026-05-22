# frozen_string_literal: true

module Decor
  module Components
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
