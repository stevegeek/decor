# frozen_string_literal: true

module Decor
  module Suite
    module Modals
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
