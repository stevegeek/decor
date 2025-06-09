# frozen_string_literal: true

module Decor
  class ClickToCopy < PhlexComponent
    private

    def view_template
      render parent_element do |el|
        div(class: "flex items-center", title: "Click to copy this.") do
          el.target_tag(:div, :content) do
            yield if block_given?
          end
          render ::Decor::Icon.new(
            name: "duplicate",
            html_options: {class: "ml-2 h-4 w-4"}
          )
        end
      end
    end

    def root_element_attributes
      {
        actions: [[:click, :copy]]
      }
    end

    def element_classes
      "cursor-pointer"
    end
  end
end
