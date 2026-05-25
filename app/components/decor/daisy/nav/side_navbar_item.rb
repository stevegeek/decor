# frozen_string_literal: true

module Decor
  module Daisy
    module Nav
      class SideNavbarItem < ::Decor::Components::Nav::SideNavbarItem
        def view_template
          root_element do |el|
            if sub_items.any?
              details(class: "decor:relative", data: {**el.stimulus_target(:details), open: resolve_selected?}) do
                summary(
                  data: {**el.stimulus_action(:click, :button_clicked)},
                  class: "decor:list-none decor:text-base-content decor:hover:bg-base-200 decor:group decor:flex decor:items-center decor:px-2 decor:py-2 decor:text-sm decor:font-medium decor:rounded-md decor:cursor-pointer"
                ) do
                  if @icon.present?
                    render ::Decor::Icon.new(
                      name: @icon,
                      html_options: {
                        class: "#{resolve_selected? ? "decor:text-primary" : "decor:text-base-content/70 decor:group-hover:text-primary"} decor:mr-3 decor:flex-shrink-0 decor:h-6 decor:w-6"
                      }
                    )
                  end

                  span(class: "#{component_name}-text #{"decor:flex-1 decor:flex decor:items-center" if @counter}") do
                    child_element(:p, stimulus_target: :title, class: "decor:shrink-0") { @title }
                    if @counter
                      span(class: "decor:d-badge decor:d-badge-primary decor:d-badge-sm decor:ml-auto") do
                        @counter.to_s
                      end
                    end
                  end

                  svg(
                    class: "#{component_name}-arrow decor:flex-shrink-0 decor:w-5 decor:h-5 decor:ml-auto decor:transform decor:duration-150 #{resolve_selected? ? class_list_for_stimulus_classes(:arrow_up) : class_list_for_stimulus_classes(:arrow_down)}",
                    **el.stimulus_target(:arrow),
                    viewBox: "0 0 20 20",
                    fill: "none"
                  ) do |s|
                    s.path(d: "M14 6L10 14L6 6L14 6Z", fill: "currentColor")
                  end
                end

                if sub_items.any?
                  ul(class: "#{component_name}-sub-items-container decor:d-menu decor:d-menu-vertical decor:w-full decor:pl-8 decor:py-2", data: {**el.stimulus_target(:sub_menu)}) do
                    sub_items.each do |sub_item|
                      render sub_item
                    end
                  end
                else
                  ul(class: "#{component_name}-sub-items-container decor:d-menu decor:d-menu-vertical decor:w-full decor:pl-8 decor:py-2", data: {**el.stimulus_target(:sub_menu)})
                end
              end
            else
              a(
                href: @path,
                class: "#{component_name}-link #{resolve_selected? ? "decor:active decor:bg-primary decor:text-primary-content" : "decor:text-base-content decor:hover:bg-base-200 decor:hover:text-primary"} decor:group decor:flex decor:items-center decor:shrink-0 decor:px-2 decor:py-2 decor:text-sm decor:font-medium decor:rounded-md"
              ) do
                if @icon.present?
                  render ::Decor::Icon.new(
                    name: @icon,
                    html_options: {
                      class: "#{resolve_selected? ? "decor:text-primary-content" : "decor:text-base-content/70 decor:group-hover:text-primary"} decor:mr-3 decor:flex-shrink-0 decor:h-6 decor:w-6"
                    }
                  )
                end

                span(class: "#{component_name}-text #{"decor:flex-1 decor:flex decor:items-center" if @counter}") do
                  child_element(:p, stimulus_target: :title, class: "decor:shrink-0") { @title }
                  if @counter
                    span(class: "decor:d-badge decor:d-badge-primary decor:d-badge-sm decor:ml-auto") do
                      @counter.to_s
                    end
                  end
                end
              end
            end
          end
        end

        private

        def root_element_attributes
          {
            element_tag: :li
          }
        end
      end
    end
  end
end
