# frozen_string_literal: true

module Decor
  module Components
    module Modals
      # Abstract base for ModalTrigger — a transparent wrapper that turns any
      # block of content (link, card, custom element) into a clickable that
      # dispatches a window-scoped modal-open event. Conceptually the more
      # flexible cousin of ModalOpenButton: the trigger is whatever the
      # consumer renders inside the block, not a button this component owns.
      #
      # The dispatched event mirrors ModalOpenButton's contract so the same
      # receiving Modal handles both, distinguishing target modal by `id`.
      #
      # Concrete skins (Daisy, Suite) provide the wrapping element + chrome.
      class ModalTrigger < ::Decor::PhlexComponent
        prop :modal_id, String, reader: :public
        prop :initial_content, _Nilable(String)
        prop :content_href, _Nilable(String)
        prop :close_on_overlay_click, _Boolean, default: false
        # Optional title forwarded in the open-event detail so the receiving
        # Modal can override its title per-click (shared-modal pattern).
        prop :title, _Nilable(String)

        stimulus do
          actions [:click, :handle_click]
          values_from_props :initial_content, :content_href, :close_on_overlay_click, :modal_id, :title
        end
      end
    end
  end
end
