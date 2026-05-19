# frozen_string_literal: true

module Decor
  module Suite
    module Modals
      # Suite skin of Modals::Information — a Suite Modal pre-wired with a
      # single Close button in the footer for displaying read-only
      # informational content (terms of service, help text, details panels).
      #
      # The caller supplies the body content as the block body.
      #
      # Example:
      #
      #   render ::Decor::Suite::Modals::Information.new(title: "Terms of Service", size: :wide) do
      #     p { "Body content here." }
      #   end
      class Information < ::Decor::Components::Modals::Information
        def view_template(&body_block)
          modal = ::Decor::Suite::Modals::Modal.new(
            id: id,
            title: @title,
            description: @description,
            variant: @variant,
            size: @size,
            closeable: true,
            start_open: @start_open
          )

          modal.with_footer do
            render close_button
          end

          if block_given?
            render modal, &body_block
          else
            render modal
          end
        end

        private

        def close_button
          ::Decor::Suite::Modals::ModalCloseButton.new(
            label: @close_label,
            size: :sm,
            color: :base,
            style: :outlined
          )
        end
      end
    end
  end
end
