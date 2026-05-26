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

          # Top-layer popover (popover="manual" — JS drives show/hide on hover).
          # Living in the top layer means no `overflow:hidden` ancestor can clip
          # it and there's no z-index war. Floating UI writes position:fixed +
          # left/top from the controller, anchored to the TRIGGER element (not
          # this root, which can be stretched full-width by a flex/grid parent).
          # Reset the UA popover chrome (margin/padding/border/bg) so only the
          # inner bubble is styled. `decor:w-max` prevents anchor-width clamping.
          div(
            popover: "manual",
            class: "decor:w-max decor:max-w-xs decor:m-0 decor:p-0 decor:border-0 decor:bg-transparent decor:transition-opacity decor:duration-suite-fast decor:ease-out",
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

      # No `relative` needed anymore: the tip is a top-layer popover positioned
      # with `position: fixed`, so it doesn't depend on a positioned ancestor.
      def root_element_classes
        "decor:inline-block"
      end
    end
  end
end
