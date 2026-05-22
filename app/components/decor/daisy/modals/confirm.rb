# frozen_string_literal: true

module Decor
  module Daisy
    module Modals
      class Confirm < ::Decor::Components::Modals::Confirm
        CONFIRM_CONTROLLER = "decor--daisy--modals--confirm"
        private_constant :CONFIRM_CONTROLLER

        def view_template
          modal = ::Decor::Daisy::Modals::Modal.new(
            id: id,
            initial_content: @message,
            start_shown: @start_open
          )

          render modal

          div(class: "decor:flex decor:justify-end decor:gap-2 decor:mt-2") do
            render ::Decor::Daisy::Modals::ModalCloseButton.new(
              label: @cancel_label,
              size: :sm,
              style: :outlined
            )
            render ::Decor::Daisy::Button.new(
              label: @confirm_label,
              size: :sm,
              color: destructive? ? :error : :primary,
              html_options: confirm_button_html_options
            )
          end
        end

        private

        def confirm_button_html_options
          data = {
            controller: CONFIRM_CONTROLLER,
            action: "click->#{CONFIRM_CONTROLLER}#confirm"
          }
          data[:"#{CONFIRM_CONTROLLER}-confirm-event-value"] = @confirm_event if @confirm_event.present?
          data[:"#{CONFIRM_CONTROLLER}-modal-id-value"] = id
          {type: "button", data: data}
        end

        def destructive?
          @variant == :destructive
        end
      end
    end
  end
end
