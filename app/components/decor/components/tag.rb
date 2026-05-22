# frozen_string_literal: true

module Decor
  module Components
    class Tag < ::Decor::PhlexComponent
      include Decor::Concerns::StyleColorClasses

      no_stimulus_controller

      prop :label, _Nilable(String)

      # Icon to display before the label
      prop :icon, _Nilable(String)

      default_size :md
      default_color :neutral
      default_style :filled

      # Whether the tag can be removed with a close button
      prop :removable, _Boolean, default: false
    end
  end
end
