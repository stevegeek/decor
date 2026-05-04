# frozen_string_literal: true

module Decor
  module Components
    module Forms
      # Abstract base for ErrorIconSection. Owns the prop API + defaults.
      # Concrete skins (Daisy, Suite) inherit and provide `view_template`
      # plus their visual-language overrides.
      class ErrorIconSection < ::Decor::PhlexComponent
        prop :error_text, _Nilable(String)
        prop :show_floating_message, _Boolean, default: false

        prop :tip_position, _Union(:top, :bottom, :left, :right), default: :right
        prop :tip_offset_percent, Integer, default: 30
      end
    end
  end
end
