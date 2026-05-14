# frozen_string_literal: true

module Decor
  module Daisy
    class ClickToCopy < ::Decor::Components::ClickToCopy
      private

      def view_template
        root_element do |el|
          div(class: "decor:flex decor:items-center", title: "Click to copy this.") do
            child_element(:div, stimulus_target: :content) do
              if block_given?
                yield
              else
                render ::Decor::Daisy::Icon.new(
                  name: "copy",
                  html_options: {class: "decor:ml-2 decor:h-4 decor:w-4"}
                )
              end
            end
          end
        end
      end

      def root_element_classes
        "decor:cursor-pointer"
      end
    end
  end
end
