# frozen_string_literal: true

module Decor
  module Components
    class Stats < ::Decor::PhlexComponent
      no_stimulus_controller

      prop :orientation, _Union(:horizontal, :vertical), default: :horizontal
      prop :shadow, _Boolean, default: true
      prop :background, _Boolean, default: false
      prop :responsive, _Boolean, default: false
    end
  end
end
