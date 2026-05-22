# frozen_string_literal: true

module Decor
  module Components
    module Modals
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
