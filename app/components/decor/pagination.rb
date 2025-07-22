# frozen_string_literal: true

module Decor
  class Pagination < PhlexComponent
    include ::Decor::Concerns::SanitisedPaginationParams
    include ::Decor::Concerns::StyleColorClasses

    no_stimulus_controller

    default_size :md
    default_color :base
    default_style :filled

    prop :page_size_selector, _Boolean, default: false

    # Pagination requires you pass a Quo::Query
    prop :collection, ::Quo::Query

    # Total count can be optionally set to override or set the total from the collection.
    # Also note if current_page is not set, it will be taken from the collection.
    prop :total_count, _Nilable(Integer)

    # Optionally set the path that the pagination links are for, else `url_for` is used
    # and thus the path is implicit based on controller and action
    prop :path, _Nilable(String)

    def view_template
      root_element do
        # Mobile pagination - simplified DaisyUI join pattern
        div(class: "flex justify-center sm:hidden") do
          div(class: "join") do
            a(href: prev_page_path, class: "join-item btn #{button_style_class} #{button_size_class}") { "Previous" }
            a(href: next_page_path, class: "join-item btn #{button_style_class} #{button_size_class}") { "Next" }
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
                  size: dropdown_size,
                  style: @style,
                  color: @color
                ) do |dropdown|
                  dropdown.trigger_button_content do
                    span(class: "text-sm") { page_size_for_selector.to_s }
                    render ::Decor::Icon.new(name: "chevron-down", style: :solid, html_options: {class: "w-4 h-4"})
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
                class: "join-item btn #{button_size_class} #{first_page? ? "btn-disabled" : button_style_class}",
                disabled: first_page?
              ) do
                render ::Decor::Icon.new(name: "chevron-left", style: :solid, html_options: {class: icon_size_class})
                span(class: "sr-only") { "Previous" }
              end

              # Page numbers and ellipses
              page_indicies_and_ellipses.each do |page|
                if page[:index].present?
                  a(
                    href: page[:path],
                    rel: page[:rel],
                    class: "join-item btn #{button_size_class} #{page[:current] ? button_active_class : button_style_class}"
                  ) { page[:index].to_s }
                else
                  # Ellipsis dropdown with DaisyUI styling
                  render ::Decor::Dropdown.new(
                    size: dropdown_size,
                    style: :ghost,
                    button_classes: ["border-y-black", "join-item"]
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
                class: "join-item btn #{button_size_class} #{last_page? ? "btn-disabled" : button_style_class}",
                disabled: last_page?
              ) do
                render ::Decor::Icon.new(name: "chevron-right", style: :solid, html_options: {class: icon_size_class})
                span(class: "sr-only") { "Next" }
              end
            end
          end
        end
      end
    end

    private

    def root_element_classes
      [
        "w-full",
        "border-t",
        "border-base-300",
        "px-4",
        "pt-5",
        "pb-3",
        "sm:px-6",
        size_classes,
        style_classes
      ].compact.join(" ")
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

    def component_style_classes(style)
      # Style affects the background and borders of the pagination container
      case style
      when :filled
        filled_color_classes(@color)
      when :outlined
        outline_color_classes(@color)
      when :ghost
        "bg-transparent"
      else
        "bg-base-100"
      end
    end

    # Helper methods for button styling based on pagination size/style/color
    def button_size_class
      case @size
      when :xs then "btn-xs"
      when :sm then "btn-sm"
      when :lg then "btn-lg"
      when :xl then "btn-lg" # xl maps to lg for buttons
      else "btn-sm" # md defaults to sm for pagination buttons
      end
    end

    def button_style_class
      case @style
      when :filled then button_color_class
      when :outlined then "btn-outline #{button_color_class}"
      when :ghost then "btn-ghost #{button_color_class}"
      else "btn-outline" # default
      end
    end

    def button_color_class
      case @color
      when :primary then "btn-primary"
      when :secondary then "btn-secondary"
      when :accent then "btn-accent"
      when :success then "btn-success"
      when :error then "btn-error"
      when :warning then "btn-warning"
      when :info then "btn-info"
      when :neutral then "btn-neutral"
      else "" # base color - no additional class needed
      end
    end

    def button_active_class
      "btn-active #{button_color_class}"
    end

    def dropdown_size
      case @size
      when :xs, :sm then :sm
      when :lg, :xl then :md
      else :sm
      end
    end

    def icon_size_class
      case @size
      when :xs then "h-3 w-3"
      when :sm then "h-4 w-4"
      when :lg then "h-5 w-5"
      when :xl then "h-6 w-6"
      else "h-4 w-4" # md default
      end
    end

    def paginated
      @collection
    end

    def current_per_page
      paginated.page_size
    end

    def current_last_index
      current_page * current_per_page
    end
  end
end
