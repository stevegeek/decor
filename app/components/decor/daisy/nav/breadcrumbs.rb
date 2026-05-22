# frozen_string_literal: true

module Decor
  module Daisy
    module Nav
      class Breadcrumbs < ::Decor::Components::Nav::Breadcrumbs
        def view_template
          root_element do
            div(class: "decor:d-breadcrumbs") do
              ul do
                render_home_item if @show_home
                render_breadcrumb_items
              end
            end

            if @mobile_select && @breadcrumbs.any?
              render_mobile_select
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
          li do
            if @home_path == current_path
              span(class: "decor:text-base-content/60", "aria-current": "page") do
                render_icon(@home_icon) if @home_icon.present?
                span(class: "decor:sr-only") { "Home" }
              end
            else
              a(href: @home_path, class: "decor:text-base-content/60 decor:hover:text-base-content") do
                render_icon(@home_icon) if @home_icon.present?
                span(class: "decor:sr-only") { "Home" }
              end
            end
          end
        end

        def render_breadcrumb_items
          @breadcrumbs.each_with_index do |crumb, index|
            li do
              if crumb.current || crumb.disabled || index == @breadcrumbs.size - 1
                span(
                  class: crumb_text_classes(current: crumb.current),
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

        def render_mobile_select
          div(class: "decor:md:hidden decor:mt-4") do
            div(class: "decor:text-sm decor:font-medium decor:text-base-content decor:mb-2") do
              plain "Mobile navigation:"
            end

            div(class: "decor:space-y-1") do
              if @show_home
                a(
                  href: @home_path,
                  class: "decor:block decor:py-2 decor:px-3 decor:rounded-md decor:text-sm #{(@home_path == current_path) ? "decor:bg-primary decor:text-primary-content" : "decor:text-base-content decor:hover:bg-base-300"}"
                ) do
                  plain "Home"
                end
              end

              @breadcrumbs.each do |crumb|
                next if crumb.disabled

                if crumb.current || crumb.path == current_path
                  div(class: "decor:block decor:py-2 decor:px-3 decor:rounded-md decor:text-sm decor:bg-primary decor:text-primary-content") do
                    plain crumb.name
                  end
                else
                  a(
                    href: crumb.path,
                    class: "decor:block decor:py-2 decor:px-3 decor:rounded-md decor:text-sm decor:text-base-content decor:hover:bg-base-300"
                  ) do
                    plain crumb.name
                  end
                end
              end
            end
          end
        end

        def render_icon(icon_name)
          return unless icon_name.present?

          begin
            render ::Decor::Icon.new(
              name: icon_name,
              html_options: {class: "decor:w-4 decor:h-4 decor:mr-1 decor:inline-block"}
            )
          rescue
            # Fallback if icon component fails
            span(class: "decor:w-4 decor:h-4 decor:mr-1 decor:inline-block") { plain ">" }
          end
        end

        def current_path
          # In a real application, this would get the current path
          # For preview/test purposes, we'll return nil
          nil
        end

        def crumb_text_classes(current: false)
          "#{current ? "decor:font-medium" : ""} decor:text-base-content/60 decor:hover:text-base-content decor:transition-colors decor:text-sm"
        end
      end
    end
  end
end
