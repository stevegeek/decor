# frozen_string_literal: true

module Decor
  module Daisy
    module Modals
      class Information < ::Decor::Components::Modals::Information
        def view_template(&body_block)
          modal = ::Decor::Daisy::Modals::Modal.new(
            id: id,
            start_shown: @start_open
          )

          if block_given?
            render modal, &body_block
          else
            render modal
          end

          # Daisy's Modals::Modal does not own a footer slot, so render the
          # Close button beside the dialog.
          div(class: "decor:flex decor:justify-end decor:gap-2 decor:mt-2") do
            render ::Decor::Daisy::Modals::ModalCloseButton.new(
              label: @close_label,
              size: :sm,
              style: :outlined
            )
          end
        end
      end
    end
  end
end
