# frozen_string_literal: true

module Decor
  module Suite
    module Modals
      class Confirm < ::Decor::Components::Modals::Confirm
        CONFIRM_CONTROLLER = "decor--suite--modals--confirm"
        private_constant :CONFIRM_CONTROLLER

        def view_template
          modal = ::Decor::Suite::Modals::Modal.new(
            id: id,
            title: @title,
            variant: @variant,
            closeable: @closeable,
            show_close_button: false,
            start_open: @start_open
          )

          modal.with_footer do
            render cancel_button
            render confirm_button
          end

          render modal do
            p(class: "decor:suite-body decor:text-gray-700") { plain @message }
          end
        end

        private

        def cancel_button
          ::Decor::Suite::Modals::ModalCloseButton.new(
            label: @cancel_label,
            size: :sm,
            color: :base,
            style: :outlined
          )
        end

        def confirm_button
          ::Decor::Suite::Button.new(
            label: @confirm_label,
            size: :sm,
            color: destructive? ? :error : :primary,
            style: :filled,
            html_options: confirm_button_html_options
          )
        end

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
