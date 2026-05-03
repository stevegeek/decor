# frozen_string_literal: true

module Decor
  module Daisy
    module Nav
      # SideNavbarItem A top-level navigation item in the side navbar.
      # Renders either an anchor (when no sub-items) or a details/summary
      # disclosure containing nested SideNavbarSubItems. Supports an icon,
      # a counter badge, and an active/selected state.
      class SideNavbarItem < ::Decor::Components::Nav::SideNavbarItem
        def view_template
          root_element do |el|
            if sub_items.any?
              details(class: "relative", data: {**el.stimulus_target(:details), open: resolve_selected?}) do
                summary(
                  data: {**el.stimulus_action(:click, :button_clicked)},
                  class: "list-none text-base-content hover:bg-base-200 group flex items-center px-2 py-2 text-sm font-medium rounded-md cursor-pointer"
                ) do
                  if @icon.present?
                    render ::Decor::Daisy::Icon.new(
                      name: @icon,
                      html_options: {
                        class: "#{resolve_selected? ? "text-primary" : "text-base-content/70 group-hover:text-primary"} mr-3 flex-shrink-0 h-6 w-6"
                      }
                    )
                  end

                  span(class: "#{component_name}-text #{@counter ? "flex-1 flex items-center" : nil}") do
                    child_element(:p, stimulus_target: :title, class: "shrink-0") { @title }
                    if @counter
                      span(class: "badge badge-primary badge-sm ml-auto") do
                        @counter.to_s
                      end
                    end
                  end

                  svg(
                    class: "#{component_name}-arrow flex-shrink-0 w-5 h-5 ml-auto transform duration-150 #{resolve_selected? ? class_list_for_stimulus_classes(:arrow_up) : class_list_for_stimulus_classes(:arrow_down)}",
                    **el.stimulus_target(:arrow),
                    viewBox: "0 0 20 20",
                    fill: "none"
                  ) do |s|
                    s.path(d: "M14 6L10 14L6 6L14 6Z", fill: "currentColor")
                  end
                end

                if sub_items.any?
                  ul(class: "#{component_name}-sub-items-container menu menu-vertical w-full pl-8 py-2", data: {**el.stimulus_target(:sub_menu)}) do
                    sub_items.each do |sub_item|
                      render sub_item
                    end
                  end
                else
                  ul(class: "#{component_name}-sub-items-container menu menu-vertical w-full pl-8 py-2", data: {**el.stimulus_target(:sub_menu)})
                end
              end
            else
              a(
                href: @path,
                class: "#{component_name}-link #{resolve_selected? ? "active bg-primary text-primary-content" : "text-base-content hover:bg-base-200 hover:text-primary"} group flex items-center shrink-0 px-2 py-2 text-sm font-medium rounded-md"
              ) do
                if @icon.present?
                  render ::Decor::Daisy::Icon.new(
                    name: @icon,
                    html_options: {
                      class: "#{resolve_selected? ? "text-primary-content" : "text-base-content/70 group-hover:text-primary"} mr-3 flex-shrink-0 h-6 w-6"
                    }
                  )
                end

                span(class: "#{component_name}-text #{@counter ? "flex-1 flex items-center" : nil}") do
                  child_element(:p, stimulus_target: :title, class: "shrink-0") { @title }
                  if @counter
                    span(class: "badge badge-primary badge-sm ml-auto") do
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
