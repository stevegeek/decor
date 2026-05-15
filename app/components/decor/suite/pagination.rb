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
        # Inline chip-row selector — each size is a direct link to the same
        # path with the new page_size. The active size is highlighted with
        # the suite-primary palette to match the active page indicator. No
        # JS dependency.
        div(class: "decor:suite-description decor:text-gray-500 decor:flex decor:items-center decor:gap-1 decor:ml-auto", role: "group", aria: {label: "Results per page"}) do
          span(class: "decor:mr-1") { plain "Per page:" }
          page_sizes.each do |s|
            a(
              href: page_size_selector_path(s),
              data: {turbo_action: "replace"},
              aria: (s == page_size) ? {current: "true"} : {},
              class: page_size_chip_classes(active: s == page_size)
            ) { plain s.to_s }
          end
        end
      end

      def page_size_chip_classes(active:)
        base = "decor:min-w-[26px] decor:h-[22px] decor:inline-flex decor:items-center decor:justify-center decor:rounded-suite-control decor:suite-description decor:font-tabular-nums decor:cursor-pointer decor:border decor:transition-all decor:duration-suite-fast decor:px-1.5"
        if active
          "#{base} decor:bg-white decor:border-suite-primary-200 decor:text-suite-primary-700 decor:font-medium"
        else
          "#{base} decor:text-gray-700 decor:border-transparent decor:hover:bg-gray-100"
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
              render_ellipsis
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

      def render_ellipsis
        span(
          aria: {hidden: "true"},
          class: "decor:min-w-[26px] decor:h-[26px] decor:inline-flex decor:items-center decor:justify-center decor:suite-description decor:text-gray-500 decor:select-none"
        ) { plain "…" }
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
