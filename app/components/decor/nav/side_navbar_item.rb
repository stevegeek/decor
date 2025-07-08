# frozen_string_literal: true

module Decor
  module Nav
    class SideNavbarItem < PhlexComponent
      include Phlex::Rails::Helpers::LinkTo

      prop :title, _String(&:present?)
      prop :icon, _Nilable(String)
      prop :path, _Nilable(String)
      prop :counter, _Nilable(Integer)
      # Also means 'expanded' where the sub items exist
      prop :selected, _Boolean, default: false
      
      stimulus do
        classes shown: "shown", 
                filtered: "filtered",
                arrow_up: "arrow_up",
                arrow_down: "arrow_down",
                open: "open",
                closed: "closed",
                entering: -> { sub_items.any? ? "rounded-md opacity-100 translate-y-0 sm:scale-100 ease-out duration-200 transform-gpu" : "" },
                leaving: -> { sub_items.any? ? "rounded-md opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95 ease-in duration-200 transform-gpu" : "" }
        values selected: -> { resolve_selected? }
      end
      
      def with_sub_item(**attributes, &block)
        @sub_items ||= []
        sub_item = SideNavbarSubItem.new(**attributes)
        @sub_items << sub_item
        yield(sub_item) if block_given?
        sub_item
      end

      def sub_items
        @sub_items ||= []
      end

      def view_template
        root_element do |el|
          if sub_items.any?
            details(class: "relative", data: {**el.stimulus_target(:details), open: resolve_selected?}) do
              summary(
                data: {**el.stimulus_action(:click, :button_clicked)},
                class: "list-none text-base-content hover:bg-base-200 group flex items-center px-2 py-2 text-sm font-medium rounded-md cursor-pointer"
              ) do
                if @icon.present?
                  render ::Decor::Icon.new(
                    name: @icon,
                    html_options: {
                      class: "#{resolve_selected? ? "text-primary" : "text-base-content/70 group-hover:text-primary"} mr-3 flex-shrink-0 h-6 w-6"
                    }
                  )
                end

                span(class: "#{component_name}-text #{@counter ? "flex-1 flex items-center" : nil}") do
                  raw(el.tag(:p, stimulus_target: :title, class: "shrink-0") { @title })
                  if @counter
                    span(class: "badge badge-primary badge-sm ml-auto") do
                      @counter.to_s
                    end
                  end
                end

                svg(
                  class: "#{component_name}-arrow flex-shrink-0 w-5 h-5 ml-auto transform duration-150 #{resolve_selected? ? el.named_classes(:arrow_up) : el.named_classes(:arrow_down)}",
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
                render ::Decor::Icon.new(
                  name: @icon,
                  html_options: {
                    class: "#{resolve_selected? ? "text-primary-content" : "text-base-content/70 group-hover:text-primary"} mr-3 flex-shrink-0 h-6 w-6"
                  }
                )
              end

              span(class: "#{component_name}-text #{@counter ? "flex-1 flex items-center" : nil}") do
                raw el.tag(:p, stimulus_target: :title, class: "shrink-0") { @title }
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

      def resolve_selected?
        @selected || sub_items.any? { |sub_item| sub_item.instance_variable_get(:@selected) }
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
