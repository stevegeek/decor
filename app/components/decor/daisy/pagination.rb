# frozen_string_literal: true

module Decor
  module Daisy
    class Pagination < ::Decor::Components::Pagination
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

            div(class: "flex items-center gap-4") do
              page_size_for_selector = page_size
              if @page_size_selector
                div(class: "flex items-center gap-2") do
                  span(class: "text-sm text-base-content/70 hidden lg:inline") { "Per page:" }
                  render ::Decor::Daisy::Dropdown.new(
                    size: dropdown_size,
                    style: @style,
                    color: @color
                  ) do |dropdown|
                    dropdown.trigger_button_content do
                      span(class: "text-sm") { page_size_for_selector.to_s }
                      render ::Decor::Daisy::Icon.new(name: "chevron-down", style: :solid, html_options: {class: "w-4 h-4"})
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

              div(class: "join") do
                a(
                  href: prev_page_path,
                  class: "join-item btn #{button_size_class} #{first_page? ? "btn-disabled" : button_style_class}",
                  disabled: first_page?
                ) do
                  render ::Decor::Daisy::Icon.new(name: "chevron-left", style: :solid, html_options: {class: icon_size_class})
                  span(class: "sr-only") { "Previous" }
                end

                page_indicies_and_ellipses.each do |page|
                  if page[:index].present?
                    a(
                      href: page[:path],
                      rel: page[:rel],
                      class: "join-item btn #{button_size_class} #{page[:current] ? button_active_class : button_style_class}"
                    ) { page[:index].to_s }
                  else
                    render ::Decor::Daisy::Dropdown.new(
                      size: dropdown_size,
                      style: :ghost,
                      button_classes: ["border-y-black", "join-item"]
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
                  class: "join-item btn #{button_size_class} #{last_page? ? "btn-disabled" : button_style_class}",
                  disabled: last_page?
                ) do
                  render ::Decor::Daisy::Icon.new(name: "chevron-right", style: :solid, html_options: {class: icon_size_class})
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

      def component_style_classes(style)
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

      def button_size_class
        case @size
        when :xs then "btn-xs"
        when :sm then "btn-sm"
        when :lg then "btn-lg"
        when :xl then "btn-lg"
        else "btn-sm"
        end
      end

      def button_style_class
        case @style
        when :filled then button_color_class
        when :outlined then "btn-outline #{button_color_class}"
        when :ghost then "btn-ghost #{button_color_class}"
        else "btn-outline"
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
        else ""
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
        else "h-4 w-4"
        end
      end
    end
  end
end
