# frozen_string_literal: true

module Decor
  module Suite
    module Nav
      class Breadcrumbs < ::Decor::Components::Nav::Breadcrumbs
        def view_template
          root_element do
            # Desktop: inline breadcrumb trail
            ol(
              role: "list",
              class: "decor:hidden decor:md:flex decor:items-center decor:gap-2 decor:suite-description decor:text-gray-500"
            ) do
              render_home_item if @show_home
              render_breadcrumb_items
            end

            # Mobile: condensed trail (+ optional select)
            if @mobile_select && @breadcrumbs.any?
              render_mobile_trail
            end
          end
        end

        private

        def root_element_attributes
          {
            element_tag: :nav,
            html_options: {"aria-label" => "Breadcrumb"}
          }
        end

        def render_home_item
          li(class: "decor:inline-flex decor:items-center") do
            if @home_path == current_path
              span(class: "decor:inline-flex decor:items-center decor:text-gray-500", aria_current: "page") do
                render_icon(@home_icon) if @home_icon.present?
                span(class: "decor:sr-only") { "Home" }
              end
            else
              a(
                href: @home_path,
                class: "decor:inline-flex decor:items-center decor:text-gray-500 decor:no-underline decor:transition-colors decor:duration-suite-fast decor:ease-out decor:hover:text-gray-900"
              ) do
                render_icon(@home_icon) if @home_icon.present?
                span(class: "decor:sr-only") { "Home" }
              end
            end
          end
        end

        def render_breadcrumb_items
          @breadcrumbs.each_with_index do |crumb, index|
            is_last = index == @breadcrumbs.size - 1
            li(class: "decor:flex decor:items-center decor:gap-2") do
              render_separator
              if crumb.current || crumb.disabled || is_last
                span(
                  class: crumb_text_classes(current: true),
                  aria_current: (crumb.current ? "page" : nil)
                ) do
                  render_icon(crumb.icon) if crumb.icon.present?
                  plain crumb.name
                end
              else
                a(
                  href: crumb.path,
                  class: crumb_text_classes
                ) do
                  render_icon(crumb.icon) if crumb.icon.present?
                  plain crumb.name
                end
              end
            end
          end
        end

        def render_mobile_trail
          div(class: "decor:flex decor:items-center decor:gap-2 decor:md:hidden") do
            if @show_home
              a(
                href: @home_path,
                class: "decor:inline-flex decor:items-center decor:text-gray-500 decor:no-underline decor:transition-colors decor:duration-suite-fast decor:ease-out decor:hover:text-gray-900"
              ) do
                render_icon(@home_icon) if @home_icon.present?
                span(class: "decor:sr-only") { "Home" }
              end
            end

            # Show only the current (last) crumb on mobile to keep the trail compact.
            current_crumb = @breadcrumbs.last
            if current_crumb
              render_separator
              span(class: "decor:suite-caption decor:text-gray-900 decor:font-medium decor:truncate") do
                plain current_crumb.name
              end
            end
          end
        end

        def render_separator
          span(class: "decor:suite-caption decor:text-gray-300", aria_hidden: "true") do
            render_separator_icon
          end
        end

        def render_separator_icon
          render ::Decor::Icon.new(
            name: @separator,
            html_options: {class: "decor:w-3.5 decor:h-3.5 decor:inline-block"}
          )
        rescue
          plain "›"
        end

        def render_icon(icon_name)
          return unless icon_name.present?

          render ::Decor::Icon.new(
            name: icon_name,
            html_options: {class: "decor:w-3.5 decor:h-3.5 decor:mr-1 decor:inline-block"}
          )
        rescue
          span(class: "decor:w-3.5 decor:h-3.5 decor:mr-1 decor:inline-block") { plain ">" }
        end

        def current_path
          # In a real application this resolves to the current request path.
          # For preview/test rendering we have no request, so return nil.
          nil
        end

        def crumb_text_classes(current: false)
          if current
            "decor:suite-description decor:text-gray-900 decor:font-medium"
          else
            "decor:suite-description decor:text-gray-500 decor:no-underline decor:transition-colors decor:duration-suite-fast decor:ease-out decor:hover:text-gray-900"
          end
        end
      end
    end
  end
end
