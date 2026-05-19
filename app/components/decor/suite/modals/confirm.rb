# frozen_string_literal: true

module Decor
  module Suite
    module Modals
      # Suite skin of Modals::Confirm — a Suite Modal pre-wired with a
      # Cancel/Confirm button pair in the footer for the canonical "are you
      # sure?" dialog pattern.
      #
      # Confirm-click behaviour (wired by the co-located Stimulus controller
      # mounted directly on the confirm <button>):
      #   1. If `confirm_event` is set, dispatches a window-scoped
      #      CustomEvent of that name (no detail).
      #   2. Dispatches the Suite Modal close event scoped to this dialog's
      #      id, so the modal closes through the same event protocol any
      #      other close-trigger uses.
      #
      # For the :destructive variant the inner Modal renders a danger-tinted
      # header and the confirm button is themed :error.
      #
      # Usage:
      #
      #   render ::Decor::Suite::Modals::Confirm.new(
      #     title: "Delete order?",
      #     message: "This can't be undone.",
      #     variant: :destructive,
      #     confirm_label: "Delete",
      #     confirm_event: "delete-order",
      #     start_open: true
      #   )
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
