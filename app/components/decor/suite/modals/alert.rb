# frozen_string_literal: true

module Decor
  module Suite
    module Modals
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
