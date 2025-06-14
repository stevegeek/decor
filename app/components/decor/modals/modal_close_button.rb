# frozen_string_literal: true

module Decor
  class ModalCloseButton < Button
    attribute :close_reason, String

    def view_template
      render ::Decor::Button.new(
        label: @label,
        icon: @icon,
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
        html_options: {type: :button, class: render_classes}
      )
    end
  end
end
