# frozen_string_literal: true

module Decor
  module Daisy
    module Modals
      class Confirm < ::Decor::Components::Modals::Confirm
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
      end
    end
  end
end
