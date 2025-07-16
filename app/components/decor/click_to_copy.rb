# frozen_string_literal: true

module Decor
  class ClickToCopy < PhlexComponent
    prop :to_copy, _Nilable(String)

    stimulus do
      actions [:click, :copy]
      values_from_props :to_copy
    end

    private

    def view_template
      root_element do |el|
        div(class: "flex items-center", title: "Click to copy this.") do
          el.tag(:div, stimulus_target: :content) do
            if block_given?
              yield
            else
              render ::Decor::Icon.new(
                name: "duplicate",
                html_options: {class: "ml-2 h-4 w-4"}
              )
            end
          end
        end
      end
    end

    def element_classes
      "cursor-pointer"
    end
  end
end
