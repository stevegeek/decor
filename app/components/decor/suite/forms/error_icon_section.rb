# frozen_string_literal: true

module Decor
  module Suite
    module Forms
      # Suite ErrorIconSection — the absolutely-positioned exclamation icon
      # that lives inside a form control's right gutter. When
      # `show_floating_message` is true, the icon is wrapped in a Tooltip
      # that surfaces the error text on hover; otherwise the icon stands
      # alone and the caption text is rendered by HelperTextSection below.
      #
      # All danger color references go through the suite-danger numbered
      # scale so the icon reads as part of the Suite palette rather than
      # the daisyUI semantic `error`.
      class ErrorIconSection < ::Decor::Components::Forms::ErrorIconSection
        def view_template
          root_element do |el|
            if @show_floating_message
              render ::Decor::Daisy::Tooltip.new(
                position: @tip_position,
                offset_percent_x: @tip_offset_percent,
                offset_percent_y: @tip_offset_percent
              ) do |tip|
                tip.with_tip_content do
                  p(
                    class: "decor:text-suite-danger-700 decor:suite-body",
                    data: error_icon_text_target_data(el)
                  ) do
                    plain @error_text if @error_text.present?
                  end
                end
                render ::Decor::Icon.new(
                  name: "exclamation-circle",
                  style: :solid,
                  html_options: {class: "decor:z-10 decor:h-5 decor:w-5 decor:text-suite-danger-500"}
                )
              end
            else
              render ::Decor::Icon.new(
                name: "exclamation-circle",
                style: :solid,
                html_options: {class: "decor:h-5 decor:w-5 decor:text-suite-danger-500"}
              )
            end
          end
        end

        private

        def error_icon_text_target_data(el)
          el.stimulus_target(:error_icon_text).to_h
        end

        def root_element_classes
          base = "decor:absolute decor:inset-y-1 decor:flex decor:items-center"
          @show_floating_message ? base : "#{base} decor:pointer-events-none"
        end
      end
    end
  end
end
