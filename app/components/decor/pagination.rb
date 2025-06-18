# frozen_string_literal: true

module Decor
  class Pagination < PhlexComponent
    include ::Decor::Concerns::SanitisedPaginationParams

    no_stimulus_controller

    attribute :page_size_selector, :boolean

    # Pagination requires you pass a Quo::Query
    attribute :collection, ::Quo::Query, allow_nil: false

    # Total count can be optionally set to override or set the total from the collection.
    # Also note if current_page is not set, it will be taken from the collection.
    attribute :total_count, Integer

    # Optionally set the path that the pagination links are for, else `url_for` is used
    # and thus the path is implicit based on controller and action
    attribute :path, String

    def view_template
      render parent_element do
        # Mobile pagination - simplified DaisyUI join pattern
        div(class: "flex justify-center sm:hidden") do
          div(class: "join") do
            a(href: prev_page_path, class: "join-item btn btn-outline btn-sm") { "Previous" }
            a(href: next_page_path, class: "join-item btn btn-outline btn-sm") { "Next" }
          end
        end

        # Desktop pagination with stats and controls
        div(class: "hidden sm:flex sm:items-center sm:justify-between sm:gap-4 w-full") do
          # Results information
          div(class: "flex-1") do
            p(class: "text-sm text-base-content/70") do
              if total_count > 0
                plain "Showing "
                span(class: "font-medium text-base-content") { start_index.to_s }
                plain " to "
                span(class: "font-medium text-base-content") { end_index.to_s }
                plain " of "
                span(class: "font-medium text-base-content") { total_count.to_s }
                plain " results"
              end
            end
          end

          # Page size selector and pagination controls
          div(class: "flex items-center gap-4") do
            # Page size selector with DaisyUI styling
            page_size_for_selector = page_size
            if @page_size_selector
              div(class: "flex items-center gap-2") do
                span(class: "text-sm text-base-content/70 hidden lg:inline") { "Per page:" }
                render ::Decor::Dropdown.new(
                  size: :sm
                ) do |dropdown|
                  dropdown.trigger_button_content do
                    span(class: "text-sm") { page_size_for_selector.to_s }
                    render ::Decor::Icon.new(name: "chevron-down", variant: :solid, html_options: {class: "w-4 h-4"})
                  end
                  page_sizes.each_with_index do |s, i|
                    dropdown.menu_item(
                      ::Decor::DropdownItem.new(
                        text: s.to_s,
                        href: page_size_selector_path(s),
                        tabindex: i
                      )
                    )
                  end
                end
              end
            end

            # Main pagination with DaisyUI join pattern
            div(class: "join") do
              # Previous button
              a(
                href: prev_page_path,
                class: "join-item btn btn-sm #{first_page? ? "btn-disabled" : "btn-outline"}",
                disabled: first_page?
              ) do
                render ::Decor::Icon.new(name: "chevron-left", variant: :solid, html_options: {class: "h-4 w-4"})
                span(class: "sr-only") { "Previous" }
              end

              # Page numbers and ellipses
              page_indicies_and_ellipses.each do |page|
                if page[:index].present?
                  a(
                    href: page[:path],
                    rel: page[:rel],
                    class: "join-item btn btn-sm #{page[:current] ? "btn-active btn-primary" : "btn-outline"}"
                  ) { page[:index].to_s }
                else
                  # Ellipsis dropdown with DaisyUI styling
                  render ::Decor::Dropdown.new(
                    size: :sm,
                    button_classes: ["btn-ghost", "border-y-black", "join-item"]
                  ) do |dropdown|
                    dropdown.trigger_button_content { "..." }
                    page[:list_of_pages_for_dropdown]&.each do |pl|
                      dropdown.menu_item(::Decor::DropdownItem.new(text: pl[:index].to_s, href: pl[:path], tabindex: pl[:index]))
                    end
                  end
                end
              end

              # Next button
              a(
                href: next_page_path,
                title: "Next page",
                class: "join-item btn btn-sm #{last_page? ? "btn-disabled" : "btn-outline"}",
                disabled: last_page?
              ) do
                render ::Decor::Icon.new(name: "chevron-right", variant: :solid, html_options: {class: "h-4 w-4"})
                span(class: "sr-only") { "Next" }
              end
            end
          end
        end
      end
    end

    private

    def element_classes
      "bg-base-100 px-4 pt-5 pb-3 w-full border-t border-base-300 sm:px-6"
    end

    # Used in view

    def current_page
      @current_page || paginated.page || 1
    end

    def page_size
      return @page_size unless @page_size.nil?
      paginated.page_size || default_page_size
    end

    def total_count
      @total_count ||= paginated.results.total_count
    end

    def start_index
      (current_page - 1) * current_per_page + 1
    end

    def end_index
      (current_last_index > total_count) ? total_count : current_last_index
    end

    # For rendering the pagination view

    def page_sizes
      return standard_page_sizes if standard_page_sizes.include?(sanitised_page_size)
      (standard_page_sizes << sanitised_page_size).sort
    end

    def first_page?
      current_page.nil? || current_page == 1
    end

    def total_page_count
      c = (total_count.to_f / sanitised_page_size).ceil
      (c < 1) ? 1 : c
    end

    def last_page?
      current_page.present? && current_page >= total_page_count
    end

    def first_page_path
      url_for_page(1)
    end

    def next_page_path
      url_for_page([current_page + 1, total_page_count].min)
    end

    def prev_page_path
      url_for_page([1, current_page - 1].max)
    end

    def last_page_path
      url_for_page(total_page_count)
    end

    def page_indicies_and_ellipses
      pages_to_display.indicies_and_ellipses
    end

    # Path for page size selector - resets page to 1
    def page_size_selector_path(page_size)
      url_for_page(1, page_size)
    end

    def pages_to_display
      @pages_to_display ||= ::Decor::Pagination::PagesToDisplay.new(current_page, total_page_count) do |page|
        url_for_page(page)
      end
    end

    def paginated
      return @collection if collection_query? || collection_collection_backed_query?
      raise StandardError, "Pagination requires a collection which can be paginated!"
    end

    def collection_relation?
      @collection.is_a? ActiveRecord::Relation
    end

    def collection_query?
      @collection.is_a?(Quo::Query) && @collection.relation?
    end

    def collection_collection_backed_query?
      @collection.is_a?(Quo::Query) && @collection.collection?
    end

    def current_per_page
      paginated.page_size
    end

    def current_last_index
      current_page * current_per_page
    end
  end
end
