# frozen_string_literal: true

module Decor
  module Suite
    class Tooltip < ::Decor::Components::Tooltip
      DEFAULT_OFFSET_PX = 8

      # Suite drives positioning from JS; opt back into the Stimulus controller
      # the abstract base disables (Daisy uses pure CSS positioning).
      has_stimulus_controller

      stimulus do
        actions [:mouseover, :mouse_over], [:mouseout, :mouse_out], [:click, :handle_click]
        values placement: -> { @position.to_s },
          offset: -> { @offset || DEFAULT_OFFSET_PX }
      end

      def with_tip_content(&block)
        @tip_content = block
        self
      end

      def tip_content? = @tip_content.present?

      def view_template(&)
        @content = capture(&) if block_given?

        root_element do
          raw safe(@content) if @content.present?

          # Floating UI writes left/top from the controller; `decor:hidden` is
          # removed on show; `decor:w-max` prevents anchor-width constraint.
          div(
            class: "decor:hidden decor:absolute decor:z-50 decor:w-max decor:max-w-xs decor:transition-opacity decor:duration-suite-fast decor:ease-out",
            style: "left: 0; top: 0;",
            data: {**stimulus_target(:content)}
          ) do
            div(class: "decor:relative decor:inline-block decor:px-2.5 decor:py-[5px] decor:bg-gray-900 decor:text-white decor:suite-description decor:rounded-suite-control decor:font-medium") do
              render_tip_content
              if arrow?
                span(
                  class: "decor:absolute decor:w-[7px] decor:h-[7px] decor:bg-gray-900 decor:rotate-45",
                  data: {**stimulus_target(:arrow)},
                  aria_hidden: "true"
                )
              end
            end
          end
        end
      end

      private

      def render_tip_content
        if @tip_content
          render @tip_content
        elsif @tip_text.present?
          plain @tip_text
        end
      end

      def root_element_classes
        "decor:inline-block decor:relative"
      end
    end
  end
end
