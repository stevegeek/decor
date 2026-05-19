# frozen_string_literal: true

module Decor
  module Components
    module Modals
      # Abstract base for Alert — a thin wrapper around Modal for simple alert
      # dialogs with a single dismissal button in the footer. Owns the prop
      # API + defaults; concrete skins (Daisy, Suite) inherit and provide
      # `view_template` plus their visual-language overrides.
      #
      # Optionally dispatches a custom DOM event when dismissed (via
      # ModalCloseButton's `close_reason`), letting listeners react to the
      # alert being acknowledged.
      class Alert < ::Decor::PhlexComponent
        no_stimulus_controller

        VARIANT_OPTIONS = ::Decor::Components::Modals::Modal::VARIANT_OPTIONS

        prop :title, String
        prop :message, String
        prop :variant, _Union(*VARIANT_OPTIONS), default: :info
        prop :button_label, String, default: "OK"
        prop :dismiss_event, _Nilable(String)
        prop :start_open, _Boolean, default: false
      end
    end
  end
end
