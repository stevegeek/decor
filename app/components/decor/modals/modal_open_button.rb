# frozen_string_literal: true

module Decor
  module Modals
    class ModalOpenButton < Button
      attribute :initial_content, String
      attribute :content_href, String
      attribute :close_on_overlay_click, :boolean, default: false

      def view_template
        render ::Decor::Button.new(
          label: @label,
          variant: @variant,
          color: @theme,
          full_width: @full_width,
          size: @size,
          icon: @icon,
          controllers: [default_controller_path],
          actions: [
            [:click, default_controller_path, :handle_button_click]
          ],
          values: [
            [default_controller_path, {
              initial_content: @initial_content,
              content_href: @content_href,
              close_on_overlay_click: @close_on_overlay_click
            }]
          ],
          disabled: @disabled,
          html_options: {type: :button, class: render_classes}
        )
      end
    end
  end
end
