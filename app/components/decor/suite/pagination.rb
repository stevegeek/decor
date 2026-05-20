# frozen_string_literal: true

module Decor
  module Suite
    # Suite Pagination — compact admin pagination row. Renders a results
    # summary on the left, an optional per-page selector in the middle, and
    # numbered page links with prev/next chevrons on the right. Uses Suite
    # design tokens (suite-hairline divider, suite-gray-25 surface, rounded-
    # suite-control hit targets, duration-suite-fast micro-interactions) and
    # tabular numerals for stable column widths.
    class Pagination < ::Decor::Components::Pagination
      def view_template
        root_element do
          render_results_summary
          render_page_size_selector if page_size_selector?
          render_page_nav
        end
      end

      private

      def page_size_selector?
        @page_size_selector
      end

      def root_element_classes
        "decor:px-5 decor:py-[10px] decor:border-t decor:border-suite-hairline decor:flex decor:items-center decor:justify-between decor:bg-suite-gray-25 decor:gap-4"
      end

      def render_results_summary
        span(class: "decor:suite-description decor:text-gray-500 decor:font-tabular-nums") do
          if total_count > 0
            plain "Showing "
            span(class: "decor:font-medium decor:text-gray-700") { plain start_index.to_s }
            plain " to "
            span(class: "decor:font-medium decor:text-gray-700") { plain end_index.to_s }
            plain " of "
            span(class: "decor:font-medium decor:text-gray-700") { plain total_count.to_s }
            plain " results"
          end
        end
      end

      def render_page_size_selector
        # Compact dropdown selector — the trigger shows the current page size
        # with a chevron and opens a menu of page-size options. Each menu item
        # links to the same path with the new page_size. No JS dependency.
        div(class: "decor:suite-description decor:text-gray-500 decor:flex decor:items-center decor:gap-1.5 decor:ml-auto") do
          plain "Per page:"
          render ::Decor::Suite::Dropdown.new(
            button_classes: %w[
              decor:inline-flex decor:items-center decor:gap-1
              decor:px-1.5 decor:h-[22px]
              decor:rounded-suite-control decor:border decor:border-transparent
              decor:hover:bg-gray-100
              decor:aria-expanded:bg-gray-100 decor:aria-expanded:border-suite-hairline-strong
            ]
          ) do |dropdown|
            dropdown.with_button_content do
              span(class: "decor:suite-description decor:text-gray-700 decor:font-tabular-nums decor:leading-none") { plain page_size.to_s }
              render ::Decor::Icon.new(name: "chevron-down", html_options: {class: "decor:w-3 decor:h-3 decor:text-gray-500 decor:shrink-0"})
            end
            page_sizes.each_with_index do |s, i|
              dropdown.with_menu_item(
                text: s.to_s,
                href: page_size_selector_path(s),
                tabindex: i
              )
            end
          end
        end
      end

      def render_page_nav
        # data-turbo-action="replace" lets Turbo morph the page when the page
        # opts in via <meta name="turbo-refresh-method" content="morph">.
        # Benign on non-Turbo pages.
        nav(class: "decor:flex decor:gap-1 decor:items-center", aria: {label: "Pagination"}) do
          render_prev_button
          page_indicies_and_ellipses.each do |page|
            if page[:index].present?
              render_page_link(page)
            else
              render_ellipsis(page)
            end
          end
          render_next_button
        end
      end

      def render_prev_button
        a(
          href: prev_page_path,
          title: "Previous page",
          rel: "prev",
          data: {turbo_action: "replace"},
          aria: first_page? ? {disabled: "true"} : {},
          class: nav_button_classes(disabled: first_page?)
        ) do
          render ::Decor::Icon.new(
            name: "chevron-left",
            html_options: {class: "decor:w-3 decor:h-3"}
          )
          span(class: "decor:sr-only") { plain "Previous" }
        end
      end

      def render_next_button
        a(
          href: next_page_path,
          title: "Next page",
          rel: "next",
          data: {turbo_action: "replace"},
          aria: last_page? ? {disabled: "true"} : {},
          class: nav_button_classes(disabled: last_page?)
        ) do
          render ::Decor::Icon.new(
            name: "chevron-right",
            html_options: {class: "decor:w-3 decor:h-3"}
          )
          span(class: "decor:sr-only") { plain "Next" }
        end
      end

      def render_page_link(page)
        a(
          href: page[:path],
          rel: page[:rel],
          data: {turbo_action: "replace"},
          aria: page[:current] ? {current: "page"} : {},
          class: page_link_classes(current: page[:current])
        ) { plain page[:index].to_s }
      end

      def render_ellipsis(page)
        # Render the ellipsis as a Suite Dropdown so users can jump to any of
        # the hidden pages within the gap. Each hidden page becomes a menu
        # item linking directly to that page.
        render ::Decor::Suite::Dropdown.new(
          button_classes: %w[
            decor:min-w-[26px] decor:h-[26px]
            decor:inline-flex decor:items-center decor:justify-center
            decor:rounded-suite-control decor:suite-description decor:text-gray-700
            decor:cursor-pointer decor:border decor:border-transparent
            decor:hover:bg-gray-100
            decor:aria-expanded:bg-gray-100 decor:aria-expanded:border-suite-hairline-strong
          ]
        ) do |dropdown|
          dropdown.with_button_content { "…" }
          page[:list_of_pages_for_dropdown]&.each do |pl|
            dropdown.with_menu_item(text: "Page #{pl[:index]}", href: pl[:path], tabindex: pl[:index])
          end
        end
      end

      def nav_button_classes(disabled:)
        base = "decor:min-w-[26px] decor:h-[26px] decor:inline-flex decor:items-center decor:justify-center decor:rounded-suite-control decor:suite-description decor:text-gray-700 decor:cursor-pointer decor:border decor:border-transparent decor:transition-all decor:duration-suite-fast decor:px-[6px] decor:hover:bg-gray-100"
        return "#{base} decor:pointer-events-none decor:opacity-40" if disabled
        base
      end

      def page_link_classes(current:)
        base = "decor:min-w-[26px] decor:h-[26px] decor:inline-flex decor:items-center decor:justify-center decor:rounded-suite-control decor:suite-description decor:font-tabular-nums decor:cursor-pointer decor:border decor:transition-all decor:duration-suite-fast decor:px-[6px]"
        if current
          "#{base} decor:bg-white decor:border-suite-primary-200 decor:text-suite-primary-700 decor:font-medium"
        else
          "#{base} decor:text-gray-700 decor:border-transparent decor:hover:bg-gray-100"
        end
      end
    end
  end
end
