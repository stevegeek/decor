# frozen_string_literal: true

module Decor
  module Daisy
    class ClickToCopy < ::Decor::Components::ClickToCopy
      private

      def view_template
        root_element do |el|
          div(class: "flex items-center", title: "Click to copy this.") do
            child_element(:div, stimulus_target: :content) do
              if block_given?
                yield
              else
                render ::Decor::Daisy::Icon.new(
                  name: "duplicate",
                  html_options: {class: "ml-2 h-4 w-4"}
                )
              end
            end
          end
        end
      end

      def root_element_classes
        "cursor-pointer"
      end
    end
  end
end
