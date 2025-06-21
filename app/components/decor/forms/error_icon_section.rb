# frozen_string_literal: true

module Decor
  module Forms
    class ErrorIconSection < PhlexComponent
      attribute :error_text, String
      attribute :show_floating_message, :boolean, default: false

      attribute :tip_position, Symbol, default: :right
      attribute :tip_offset_percent, Integer, default: 30

      def view_template
        render parent_element do |el|
          if @show_floating_message
            render ::Decor::Tooltip.new(position: @tip_position, offset_percent_x: @tip_offset_percent, offset_percent_y: @tip_offset_percent) do |tip|
              tip.tip_content do
                p(class: "text-error text-sm", **el.as_target(:error_text)) do
                  @error_text
                end
              end
              render ::Decor::Icon.new(name: "exclamation-circle", variant: :solid, html_options: {class: "z-10 h-5 w-5 text-red-500"})
            end
          else
            render ::Decor::Icon.new(name: "exclamation-circle", variant: :solid, html_options: {class: "h-5 w-5 text-red-500"})
          end
        end
      end

      private

      def element_classes
        "absolute inset-y-1 flex items-center #{@show_floating_message ? "" : "no-pointer-events"}"
      end
    end
  end
end
