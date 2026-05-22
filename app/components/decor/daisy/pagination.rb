# frozen_string_literal: true

module Decor
  module Daisy
    class Pagination < ::Decor::Components::Pagination
      def view_template
        root_element do
          # Mobile pagination - simplified DaisyUI join pattern
          div(class: "decor:flex decor:justify-center decor:sm:hidden") do
            div(class: "decor:d-join") do
              a(href: prev_page_path, class: "decor:d-join-item decor:d-btn #{button_style_class} #{button_size_class}") { "Previous" }
              a(href: next_page_path, class: "decor:d-join-item decor:d-btn #{button_style_class} #{button_size_class}") { "Next" }
            end
          end

          # Desktop pagination with stats and controls
          div(class: "decor:hidden decor:sm:flex decor:sm:items-center decor:sm:justify-between decor:sm:gap-4 decor:w-full") do
            div(class: "decor:flex-1") do
              p(class: "decor:text-sm decor:text-base-content/70") do
                if total_count > 0
                  plain "Showing "
                  span(class: "decor:font-medium decor:text-base-content") { start_index.to_s }
                  plain " to "
                  span(class: "decor:font-medium decor:text-base-content") { end_index.to_s }
                  plain " of "
                  span(class: "decor:font-medium decor:text-base-content") { total_count.to_s }
                  plain " results"
                end
              end
            end

            div(class: "decor:flex decor:items-center decor:gap-4") do
              page_size_for_selector = page_size
              if @page_size_selector
                div(class: "decor:flex decor:items-center decor:gap-2") do
                  span(class: "decor:text-sm decor:text-base-content/70 decor:hidden decor:lg:inline") { "Per page:" }
                  render ::Decor::Daisy::Dropdown.new(
                    size: dropdown_size,
                    style: @style,
                    color: @color
                  ) do |dropdown|
                    dropdown.trigger_button_content do
                      span(class: "decor:text-sm") { page_size_for_selector.to_s }
                      render ::Decor::Icon.new(name: "chevron-down", style: :solid, html_options: {class: "decor:w-4 decor:h-4"})
                    end
                    page_sizes.each_with_index do |s, i|
                      dropdown.menu_item(
                        ::Decor::Daisy::DropdownItem.new(
                          text: s.to_s,
                          href: page_size_selector_path(s),
                          tabindex: i
                        )
                      )
                    end
                  end
                end
              end

              div(class: "decor:d-join") do
                a(
                  href: prev_page_path,
                  class: "decor:d-join-item decor:d-btn #{button_size_class} #{first_page? ? "decor:d-btn-disabled" : button_style_class}",
                  disabled: first_page?
                ) do
                  render ::Decor::Icon.new(name: "chevron-left", style: :solid, html_options: {class: icon_size_class})
                  span(class: "decor:sr-only") { "Previous" }
                end

                page_indicies_and_ellipses.each do |page|
                  if page[:index].present?
                    a(
                      href: page[:path],
                      rel: page[:rel],
                      class: "decor:d-join-item decor:d-btn #{button_size_class} #{page[:current] ? button_active_class : button_style_class}"
                    ) { page[:index].to_s }
                  else
                    render ::Decor::Daisy::Dropdown.new(
                      size: dropdown_size,
                      style: :ghost,
                      button_classes: ["decor:border-y-black", "decor:d-join-item"]
                    ) do |dropdown|
                      dropdown.trigger_button_content { "..." }
                      page[:list_of_pages_for_dropdown]&.each do |pl|
                        dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: pl[:index].to_s, href: pl[:path], tabindex: pl[:index]))
                      end
                    end
                  end
                end

                a(
                  href: next_page_path,
                  title: "Next page",
                  class: "decor:d-join-item decor:d-btn #{button_size_class} #{last_page? ? "decor:d-btn-disabled" : button_style_class}",
                  disabled: last_page?
                ) do
                  render ::Decor::Icon.new(name: "chevron-right", style: :solid, html_options: {class: icon_size_class})
                  span(class: "decor:sr-only") { "Next" }
                end
              end
            end
          end
        end
      end

      private

      def root_element_classes
        [
          "decor:w-full",
          "decor:border-t",
          "decor:border-base-300",
          "decor:px-4",
          "decor:pt-5",
          "decor:pb-3",
          "decor:sm:px-6",
          size_classes,
          style_classes
        ].compact.join(" ")
      end

      def component_style_classes(style)
        case style
        when :filled
          filled_color_classes(@color)
        when :outlined
          outline_color_classes(@color)
        when :ghost
          "decor:bg-transparent"
        else
          "decor:bg-base-100"
        end
      end

      def button_size_class
        case @size
        when :xs then "decor:d-btn-xs"
        when :sm then "decor:d-btn-sm"
        when :lg then "decor:d-btn-lg"
        when :xl then "decor:d-btn-lg"
        else "decor:d-btn-sm"
        end
      end

      def button_style_class
        case @style
        when :filled then button_color_class
        when :outlined then "decor:d-btn-outline #{button_color_class}"
        when :ghost then "decor:d-btn-ghost #{button_color_class}"
        else "decor:d-btn-outline"
        end
      end

      def button_color_class
        case @color
        when :primary then "decor:d-btn-primary"
        when :secondary then "decor:d-btn-secondary"
        when :accent then "decor:d-btn-accent"
        when :success then "decor:d-btn-success"
        when :error then "decor:d-btn-error"
        when :warning then "decor:d-btn-warning"
        when :info then "decor:d-btn-info"
        when :neutral then "decor:d-btn-neutral"
        else ""
        end
      end

      def button_active_class
        "decor:d-btn-active #{button_color_class}"
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
        when :xs then "decor:h-3 decor:w-3"
        when :sm then "decor:h-4 decor:w-4"
        when :lg then "decor:h-5 decor:w-5"
        when :xl then "decor:h-6 decor:w-6"
        else "decor:h-4 decor:w-4"
        end
      end
    end
  end
end
