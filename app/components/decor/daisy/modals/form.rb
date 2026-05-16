# frozen_string_literal: true

module Decor
  module Daisy
    module Modals
      # Daisy skin of Modals::Form. Composes Daisy::Modals::Modal with a
      # pre-wired Cancel/Submit footer; the form body is provided by the
      # caller (inline block or lazily via `content_href`).
      class Form < ::Decor::Components::Modals::Form
        def view_template(&body_block)
          modal = ::Decor::Daisy::Modals::Modal.new(
            id: id,
            initial_content: @initial_content,
            content_href: @content_href,
            start_shown: @start_open
          )

          if block_given?
            render modal, &body_block
          else
            render modal
          end

          # Daisy's Modals::Modal does not own a footer slot, so render the
          # Cancel/Submit pair beside the dialog. Callers needing tighter
          # chrome should reach for the Suite skin which integrates the
          # footer with the dialog body.
          div(class: "decor:flex decor:justify-end decor:gap-2 decor:mt-2") do
            render ::Decor::Daisy::Modals::ModalCloseButton.new(
              label: @cancel_label,
              size: :sm,
              style: :outlined
            )
            render ::Decor::Daisy::Button.new(
              label: @submit_label,
              size: :sm,
              color: @submit_color,
              html_options: {type: "submit", form: form_id}
            )
          end
        end
      end
    end
  end
end
