# frozen_string_literal: true

module Decor
  module Components
    module Modals
      # Abstract base for ModalCloseButton. Inherits from Components::Button
      # (gets the full button prop API + slot helpers) and adds the
      # close_reason prop plus the stimulus block.
      # Concrete skins (Daisy, Suite) inherit and provide the visual-language
      # rendering.
      class ModalCloseButton < ::Decor::Components::Button
        prop :close_reason, _Nilable(String)

        stimulus do
          actions [:click, :handle_button_click]
          values_from_props :close_reason
        end
      end
    end
  end
end
