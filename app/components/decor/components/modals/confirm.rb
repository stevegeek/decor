# frozen_string_literal: true

module Decor
  module Components
    module Modals
      class Confirm < ::Decor::PhlexComponent
        # The confirm Stimulus controller is mounted on the inner confirm
        # button (see #confirm_button_html_options), not on a component root,
        # so there is no root data-controller to auto-attach.
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

        private

        # Shared button wiring for every skin. The stimulus_* helpers resolve
        # against each concrete subclass's own implied controller
        # (decor--daisy--modals--confirm / decor--suite--modals--confirm),
        # which matches that skin's confirm_controller.js.
        def confirm_button_html_options
          data = {
            **stimulus_controller.to_h,
            **stimulus_action(:click, :confirm).to_h
          }
          data.merge!(stimulus_value(:confirm_event, @confirm_event).to_h) if @confirm_event.present?
          data.merge!(stimulus_value(:modal_id, id).to_h)
          {type: "button", data: data}
        end

        def destructive?
          @variant == :destructive
        end
      end
    end
  end
end
