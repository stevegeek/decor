# frozen_string_literal: true

module Decor
  module Suite
    module Modals
      # Suite skin of Alert — a thin wrapper around Suite::Modals::Modal for
      # simple alert dialogs with a single dismissal button in the footer.
      # Severity-colored chrome is delegated to the wrapped Modal's variant.
      #
      # Usage:
      #   render ::Decor::Suite::Modals::Alert.new(
      #     title: "Couldn't save",
      #     message: "Please try again.",
      #     variant: :danger,
      #     button_label: "OK",
      #     dismiss_event: "order-save-failed",
      #     start_open: true
      #   )
      class Alert < ::Decor::Components::Modals::Alert
        def view_template
          modal = ::Decor::Suite::Modals::Modal.new(
            variant: @variant,
            title: @title,
            closeable: true,
            start_open: @start_open
          )

          modal.with_footer do
            render dismiss_button
          end

          render modal do
            p(class: "decor:suite-body") { plain @message }
          end
        end

        private

        # Color the dismiss button to echo the alert's severity so the OK
        # affordance reads as the natural acknowledgement for the chrome
        # the user just saw — neutral chrome → neutral button, danger
        # chrome → danger-tinted button.
        def dismiss_button
          opts = {label: @button_label, size: :sm, color: dismiss_button_color}
          opts[:close_reason] = @dismiss_event if @dismiss_event.present?
          ::Decor::Suite::Modals::ModalCloseButton.new(**opts)
        end

        def dismiss_button_color
          case @variant
          when :danger, :destructive then :error
          when :warning then :warning
          when :success then :success
          when :info then :primary
          else :base
          end
        end
      end
    end
  end
end
