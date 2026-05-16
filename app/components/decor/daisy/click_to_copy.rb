# frozen_string_literal: true

module Decor
  module Daisy
    class ClickToCopy < ::Decor::Components::ClickToCopy
      # :chip — bordered pill (default); :inline — bare inline trigger with
      # subtle copy icon. Mirrors the Suite skin's two-variant API.
      prop :variant, _Union(:chip, :inline), default: :chip

      def view_template
        root_element do |el|
          div(class: "decor:flex decor:items-center", title: "Click to copy this.") do
            child_element(:div, stimulus_target: :content) do
              if block_given?
                yield
              else
                render ::Decor::Icon.new(
                  name: "copy",
                  html_options: {class: "decor:ml-2 decor:h-4 decor:w-4"}
                )
              end
            end
          end
        end
      end

      private

      def root_element_classes
        if @variant == :inline
          "decor:cursor-pointer decor:hover:underline"
        else
          "decor:cursor-pointer"
        end
      end
    end
  end
end
