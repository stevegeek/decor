# frozen_string_literal: true

module Decor
  module Suite
    module Nav
      class SideNavbarItem < ::Decor::Components::Nav::SideNavbarItem
        def view_template
          root_element do |el|
            if sub_items.any?
              details(class: "decor:relative", data: {**el.stimulus_target(:details), open: resolve_selected?}) do
                summary(
                  data: {**el.stimulus_action(:click, :button_clicked)},
                  class: "#{component_name}-link decor:list-none decor:group decor:flex decor:items-center decor:gap-3 decor:px-3 decor:py-2 decor:my-px decor:suite-description decor:font-medium decor:rounded-suite-control decor:cursor-pointer decor:duration-suite-fast decor:ease-out #{summary_state_classes}"
                ) do
                  if @icon.present?
                    render ::Decor::Icon.new(
                      name: @icon,
                      html_options: {
                        class: "#{component_name}-icon #{resolve_selected? ? "decor:text-suite-primary-700" : "decor:text-gray-500 decor:group-hover:text-gray-900"} decor:shrink-0 decor:h-5 decor:w-5"
                      }
                    )
                  end

                  span(class: "#{component_name}-text #{"decor:flex-1 decor:flex decor:items-center" if @counter}") do
                    child_element(:p, stimulus_target: :title, class: "decor:shrink-0") { @title }
                    if @counter
                      span(class: "decor:inline-flex decor:items-center decor:px-2 decor:py-0.5 decor:rounded-full decor:suite-caption decor:font-medium decor:bg-gray-100 decor:text-gray-600 decor:ml-auto") do
                        @counter.to_s
                      end
                    end
                  end

                  svg(
                    class: "#{component_name}-arrow decor:shrink-0 decor:w-4 decor:h-4 decor:ml-auto decor:text-gray-400 decor:transform decor:duration-suite-fast decor:ease-out #{resolve_selected? ? class_list_for_stimulus_classes(:arrow_up) : class_list_for_stimulus_classes(:arrow_down)}",
                    **el.stimulus_target(:arrow),
                    viewBox: "0 0 20 20",
                    fill: "none"
                  ) do |s|
                    s.path(d: "M14 6L10 14L6 6L14 6Z", fill: "currentColor")
                  end
                end

                ul(class: "#{component_name}-sub-items-container decor:w-full decor:ml-7 decor:pl-1 decor:mt-px decor:mb-1 decor:border-l decor:border-suite-hairline", data: {**el.stimulus_target(:sub_menu)}) do
                  sub_items.each do |sub_item|
                    render sub_item
                  end
                end
              end
            else
              a(
                href: @path,
                class: "#{component_name}-link decor:group decor:flex decor:items-center decor:gap-3 decor:shrink-0 decor:px-3 decor:py-2 decor:my-px decor:suite-description decor:font-medium decor:rounded-suite-control decor:duration-suite-fast decor:ease-out #{link_state_classes}"
              ) do
                if @icon.present?
                  render ::Decor::Icon.new(
                    name: @icon,
                    html_options: {
                      class: "#{component_name}-icon #{resolve_selected? ? "decor:text-suite-primary-700" : "decor:text-gray-500 decor:group-hover:text-gray-900"} decor:shrink-0 decor:h-5 decor:w-5"
                    }
                  )
                end

                span(class: "#{component_name}-text #{"decor:flex-1 decor:flex decor:items-center" if @counter}") do
                  child_element(:p, stimulus_target: :title, class: "decor:shrink-0") { @title }
                  if @counter
                    span(class: "decor:inline-flex decor:items-center decor:px-2 decor:py-0.5 decor:rounded-full decor:suite-caption decor:font-medium decor:bg-gray-100 decor:text-gray-600 decor:ml-auto") do
                      @counter.to_s
                    end
                  end
                end
              end
            end
          end
        end

        # Override the slot factory so the item nests Suite sub-items (the
        # abstract base hard-codes the Daisy sub-item class).
        def with_sub_item(**attributes, &block)
          @sub_items ||= []
          sub_item = ::Decor::Suite::Nav::SideNavbarSubItem.new(**attributes)
          @sub_items << sub_item
          yield(sub_item) if block_given?
          sub_item
        end

        private

        # Active items get the primary-tinted surface plus an inset accent bar
        # on the leading edge; inactive items use the neutral hover treatment.
        def link_state_classes
          if resolve_selected?
            "decor:bg-suite-primary-50 decor:text-suite-primary-700 decor:shadow-[inset_2px_0_0_var(--color-suite-primary-500)]"
          else
            "decor:text-gray-700 decor:hover:bg-gray-50 decor:hover:text-gray-900"
          end
        end
        alias_method :summary_state_classes, :link_state_classes

        def root_element_attributes
          {
            element_tag: :li
          }
        end
      end
    end
  end
end
