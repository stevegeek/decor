# frozen_string_literal: true

module Decor
  module Modals
    class ModalCloseButton < Button
      attribute :close_reason, String

      def view_template(&block)
        @content = capture(&block) if block_given?

        render ::Decor::Button.new(
          label: @content || @label,
          icon: @icon || "x-mark",
          variant: @variant,
          color: @theme,
          full_width: @full_width,
          size: @size,
          controllers: [default_controller_path],
          actions: [
            [:click, default_controller_path, :handle_button_click]
          ],
          values: [
            [default_controller_path, {close_reason: @close_reason}]
          ],
          disabled: @disabled,
          html_options: {type: :button, **(@html_options || {}), class: [render_classes, @html_options&.dig(:class)].compact.join(" ")}
        )
      end
    end
  end
end
