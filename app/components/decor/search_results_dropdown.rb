# frozen_string_literal: true

module Decor
  class SearchResultsDropdown < PhlexComponent
    prop :nav_element, Vident::StimulusComponent

    def view_template
      root_element do
        # Presentational element used to render the bottom shadow, if we put the shadow on the actual panel it pokes out the top, so we use this shorter element to hide the top of the shadow
        div(class: "absolute inset-0 top-1/2 bg-white shadow-xl", aria_hidden: "true")

        div(class: "relative bg-white h-full overflow-hidden") do
          div(class: "flex items-center h-full", data: {**@nav_element.stimulus_target(:search_spinner)}) do
            render ::Decor::Spinner.new(classes: "mx-auto")
          end
          div(class: "hidden max-w-7xl mx-auto px-8 h-full overflow-y-scroll lg:overflow-auto", data: {**@nav_element.stimulus_target(:search_dropdown_content)}) do
            # Search results view goes here
          end
        end
      end
    end

    private

    def element_classes
      "hidden absolute top-full inset-x-0 text-sm text-gray-500 h-[375px] border-l border-r border-b border-gray-200"
    end
  end
end
