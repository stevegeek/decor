# frozen_string_literal: true

module Decor
  class ClickToCopy < PhlexComponent
    stimulus do
      actions [:click, :copy]
    end

    private

    def view_template
      root_element do |el|
        div(class: "flex items-center", title: "Click to copy this.") do
          el.tag(:div, stimulus_target: :content) do
            yield if block_given?
          end
          render ::Decor::Icon.new(
            name: "duplicate",
            html_options: {class: "ml-2 h-4 w-4"}
          )
        end
      end
    end

    def element_classes
      "cursor-pointer"
    end
  end
end
