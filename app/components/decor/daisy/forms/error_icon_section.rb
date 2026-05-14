# frozen_string_literal: true

module Decor
  module Daisy
    module Forms
      class ErrorIconSection < ::Decor::Components::Forms::ErrorIconSection
        def view_template
          root_element do |el|
            if @show_floating_message
              render ::Decor::Daisy::Tooltip.new(position: @tip_position, offset_percent_x: @tip_offset_percent, offset_percent_y: @tip_offset_percent) do |tip|
                tip.with_tip_content do
                  p(class: "decor:text-error decor:text-sm", **el.as_target(:error_text)) do
                    @error_text
                  end
                end
                render ::Decor::Daisy::Icon.new(name: "exclamation-circle", style: :solid, html_options: {class: "decor:z-10 decor:h-5 decor:w-5 decor:text-red-500"})
              end
            else
              render ::Decor::Daisy::Icon.new(name: "exclamation-circle", style: :solid, html_options: {class: "decor:h-5 decor:w-5 decor:text-red-500"})
            end
          end
        end

        private

        # CODEMOD-REVIEW: interpolated class expression — verify "no-pointer-events" inside ternary is already prefixed or prefix manually
        def root_element_classes
          "decor:absolute decor:inset-y-1 decor:flex decor:items-center #{@show_floating_message ? "" : "no-pointer-events"}"
        end
      end
    end
  end
end
