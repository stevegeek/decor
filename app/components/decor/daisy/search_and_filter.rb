# frozen_string_literal: true

module Decor
  module Daisy
    class SearchAndFilter < ::Decor::Components::SearchAndFilter
      def view_template(&block)
        vanish(&block) if block
        root_element do |el|
          form(method: "get", action: @url) do
            div(class: "decor:sm:flex decor:sm:rounded-md decor:sm:shadow-sm") do
              div(class: "decor:relative decor:flex-grow decor:focus-within:z-10") do
                if @search.present?
                  render ::Decor::Daisy::Forms::TextField.new(
                    name: @search.name,
                    label: @search.label,
                    value: @search.value,
                    label_position: :inside,
                    leading_icon_name: "search",
                    collapsing_helper_text: true,
                    control_targets: [
                      stimulus_target(:search_input)
                    ],
                    control_actions: [
                      stimulus_action(:keydown, :handle_search_input_keydown)
                    ],
                    stimulus_outlet_host: el,
                    control_html_options: {class: @filters.present? ? "decor:rounded-md decor:sm:rounded-l-md decor:sm:rounded-r-none decor:pl-10" : "decor:rounded-md"},
                    object: nil,
                    object_name: nil,
                    method_name: nil,
                    validations: nil
                  )
                end
              end

              if @filters.present?
                render ::Decor::Daisy::Dropdown.new(
                  position: :right,
                  stimulus_outlet_host: el
                ) do |dropdown|
                  filters_active = filters_on?
                  component_filters = @filters
                  dropdown.trigger_button do
                    button(
                      type: "button",
                      # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
                      class: "decor:-ml-px decor:relative decor:inline-flex decor:items-center decor:px-4 decor:py-2 decor:mt-4 decor:sm:mt-0 decor:w-full decor:sm:w-auto decor:border decor:border-gray-300 decor:text-sm decor:font-medium #{@search.present? ? "decor:rounded-md decor:sm:rounded-r-md decor:sm:rounded-l-none" : "decor:rounded-md"} decor:text-gray-700 decor:bg-white decor:sm:bg-gray-50 decor:hover:bg-gray-100 decor:focus:outline-none decor:focus:ring-1 decor:focus:ring-blue-500 decor:focus:border-blue-500",
                      data: {**stimulus_actions([:click, :toggle], [:"click@window", :hide_on_click_outside])}
                    ) do
                      render ::Decor::Icon.new(
                        name: "filter",
                        style: filters_active ? :solid : :outline,
                        html_options: {class: "decor:h-5 decor:w-5 decor:text-gray-400"}
                      )

                      span(class: "decor:ml-auto decor:mr-2 decor:sm:ml-2") { "Filter" }
                      render ::Decor::Icon.new(name: "chevron-down", style: :solid, html_options: {class: "decor:h-5 decor:w-5 decor:text-gray-400"})
                    end
                  end

                  dropdown.menu_content do
                    div(class: "decor:space-y-2 decor:p-4") do
                      component_filters.each do |filter|
                        case filter.type
                        when :select
                          render ::Decor::Daisy::Forms::Select.new(
                            name: filter.name,
                            label: filter.label,
                            value: filter.value,
                            options_array: filter.options,
                            selected_option: filter.value,
                            disabled: filter.disabled,
                            disabled_options: filter.disabled_options,
                            disable_blank_option: false,
                            label_position: :inside,
                            collapsing_helper_text: true,
                            classes: "decor:pt-2 decor:w-full",
                            stimulus_outlet_host: el
                          )
                        when :checkbox
                          render ::Decor::Daisy::Forms::Checkbox.new(
                            name: filter.name,
                            label: filter.label,
                            checked: filter.value == "true",
                            disabled: filter.disabled,
                            collapsing_helper_text: true,
                            classes: "decor:pt-2 decor:w-full",
                            stimulus_outlet_host: el
                          )
                        when :date_range
                          render ::Decor::Daisy::Forms::TextField.new(
                            label_position: :inside,
                            name: filter.name,
                            label: filter.label,
                            value: filter.value,
                            disabled: filter.disabled,
                            collapsing_helper_text: true,
                            control_actions: [
                              stimulus_action(:focus, :handle_range_picker)
                            ],
                            classes: "decor:pt-2 decor:w-full",
                            stimulus_outlet_host: el
                          )
                        end
                      end
                    end

                    div(class: "decor:space-y-4 decor:p-4 decor:border-t decor:border-gray-200") do
                      if filters_active
                        render ::Decor::Daisy::Button.new(
                          label: "Clear filters",
                          stimulus_targets: [stimulus_target(:clear_filters_button)],
                          stimulus_actions: [stimulus_action(:click, :handle_clear_filters)],
                          icon: "x",
                          size: :small,
                          color: :error,
                          style: :outlined,
                          full_width: true
                        )
                      end

                      render ::Decor::Daisy::Button.new(
                        label: "Apply",
                        stimulus_targets: [stimulus_target(:apply_button)],
                        stimulus_actions: [stimulus_action(:click, :handle_apply)],
                        size: :small,
                        color: :primary,
                        full_width: true
                      )
                    end
                  end
                end
              end
            end

            if @filters_slot.present?
              # CODEMOD-REVIEW: filters-slot is a custom/non-utility class — leave unprefixed
              div(class: "filters-slot") do
                raw(@filters_slot.call.html_safe)
              end
            end

            if @download_path.present?
              a(
                href: @download_path,
                method: :post,
                class: "decor:w-[38px] decor:h-[38px] decor:flex-shrink-0 decor:grid decor:place-content-center decor:border decor:border-gray-300 decor:rounded-md decor:shadow-sm decor:bg-white decor:hover:bg-gray-50 decor:focus:outline-none",
                data: {confirm: "Do you wish to download the data currently shown in the table?", "confirm-yes": "Yes, download"}
              ) do
                render ::Decor::Icon.new(name: "download", html_options: {class: "decor:h-4 decor:w-4 decor:text-blue-500"})
              end
            end

            if @actions.present?
              div(class: "decor:mt-4 decor:sm:mt-0", &@actions)
            end
          end
        end
      end

      private

      def root_element_classes
        "decor:sm:flex decor:sm:items-center decor:space-x-0 decor:sm:space-x-4 decor:mt-3 decor:sm:mt-0 decor:sm:ml-4"
      end
    end
  end
end
