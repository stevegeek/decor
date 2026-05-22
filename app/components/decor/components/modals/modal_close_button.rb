# frozen_string_literal: true

module Decor
  module Components
    module Modals
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
