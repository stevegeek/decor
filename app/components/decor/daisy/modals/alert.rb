# frozen_string_literal: true

module Decor
  module Daisy
    module Modals
      class Alert < ::Decor::Components::Modals::Alert
        def view_template
          modal = ::Decor::Daisy::Modals::Modal.new(
            variant: @variant,
            title: @title,
            closeable: true,
            start_open: @start_open,
            initial_content: @message
          )

          render modal
          render dismiss_button
        end

        private

        def dismiss_button
          opts = {label: @button_label, size: :sm}
          opts[:close_reason] = @dismiss_event if @dismiss_event.present?
          ::Decor::Daisy::Modals::ModalCloseButton.new(**opts)
        end
      end
    end
  end
end
