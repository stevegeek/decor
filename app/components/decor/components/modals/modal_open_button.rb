# frozen_string_literal: true

module Decor
  module Components
    module Modals
      class ModalOpenButton < ::Decor::Components::Button
        prop :modal_id, String, reader: :public
        prop :initial_content, _Nilable(String)
        prop :content_href, _Nilable(String)
        prop :close_on_overlay_click, _Boolean, default: false
        prop :type, _Nilable(String), default: "button"
        # Optional title forwarded in the open-event detail so the receiving
        # Modal can override its title per-click (shared-modal pattern).
        prop :title, _Nilable(String)

        stimulus do
          actions [:click, :handle_button_click]
          values_from_props :initial_content, :content_href, :close_on_overlay_click, :modal_id, :title
        end
      end
    end
  end
end
