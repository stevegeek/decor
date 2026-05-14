# frozen_string_literal: true

module Decor
  module Daisy
    # SearchResultsDropdown A dropdown panel that displays search results
    # underneath a navigation search input. Shows a loading spinner while
    # results are being fetched and a scrollable content area for results.
    class SearchResultsDropdown < ::Decor::Components::SearchResultsDropdown
      def view_template
        root_element do
          # Presentational element used to render the bottom shadow, if we put the shadow on the actual panel it pokes out the top, so we use this shorter element to hide the top of the shadow
          div(class: "decor:absolute decor:inset-0 decor:top-1/2 decor:bg-white decor:shadow-xl", aria_hidden: "true")

          div(class: "decor:relative decor:bg-white decor:h-full decor:overflow-hidden") do
            div(class: "decor:flex decor:items-center decor:h-full", data: {**@nav_element.stimulus_target(:search_spinner)}) do
              render ::Decor::Daisy::Spinner.new(classes: "decor:mx-auto")
            end
            div(class: "decor:hidden decor:max-w-7xl decor:mx-auto decor:px-8 decor:h-full decor:overflow-y-scroll decor:lg:overflow-auto", data: {**@nav_element.stimulus_target(:search_dropdown_content)}) do
              # Search results view goes here
            end
          end
        end
      end

      private

      def root_element_classes
        "decor:hidden decor:absolute decor:top-full decor:inset-x-0 decor:text-sm decor:text-gray-500 decor:h-[375px] decor:border-l decor:border-r decor:border-b decor:border-gray-200"
      end
    end
  end
end
