# frozen_string_literal: true

module Decor
  module Components
    module Modals
      # Abstract base for Modals::Confirm. Owns the prop API for a thin Modal
      # wrapper that renders a confirmation dialog with a Cancel + Confirm
      # button pair in the footer.
      #
      # On confirm-click the concrete skin dispatches:
      #   1. (Optional) a named CustomEvent on `window` carrying the
      #      `confirm_event` string — listeners react to the user's intent.
      #   2. The modal-close event for its skin's modal — so the dialog
      #      closes via the same event protocol any other close-trigger uses.
      #
      # Concrete skins (Daisy, Suite) inherit and provide `view_template`
      # plus their visual-language overrides.
      class Confirm < ::Decor::PhlexComponent
        no_stimulus_controller

        VARIANT_OPTIONS = %i[neutral info success warning danger destructive].freeze

        prop :title, String
        prop :message, String
        prop :variant, _Union(*VARIANT_OPTIONS), default: :info
        prop :confirm_label, String, default: "Confirm"
        prop :cancel_label, String, default: "Cancel"
        # Optional window-scoped CustomEvent name dispatched on confirm click.
        prop :confirm_event, _Nilable(String), default: nil
        prop :start_open, _Boolean, default: false
        prop :closeable, _Boolean, default: true
      end
    end
  end
end
