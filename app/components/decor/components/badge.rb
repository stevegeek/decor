# frozen_string_literal: true

module Decor
  module Components
    class Badge < ::Decor::PhlexComponent
      no_stimulus_controller

      prop :label, _Nilable(String)
      prop :dashed, _Boolean, default: false

      default_size :md
      default_style :outlined
      default_color :neutral

      prop :icon, _Nilable(String)

      # Optional avatar
      prop :url, _Nilable(String)
      prop :initials, _Nilable(String)
    end
  end
end
