# frozen_string_literal: true

module Decor
  module Components
    module Forms
      class ErrorIconSection < ::Decor::PhlexComponent
        prop :error_text, _Nilable(String)
        prop :show_floating_message, _Boolean, default: false

        prop :tip_position, _Union(:top, :bottom, :left, :right), default: :right
        prop :tip_offset_percent, Integer, default: 30
      end
    end
  end
end
