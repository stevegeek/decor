# frozen_string_literal: true

module Decor
  class SearchAndFilter < PhlexComponent
    include ::Decor::Concerns::SanitisedSortAndFilterParams

    class Filter < Literal::Data
      prop :type, _Union(:select, :checkbox, :date_range)
      prop :name, String
      prop :label, String
      prop :value, String

      prop :disabled, _Boolean, default: false

      prop :options, Array, default: [].freeze
      prop :disabled_options, Array, default: [].freeze

      prop :apply, _Nilable(Proc)
    end

    class Search < Literal::Data
      prop :name, String
      prop :label, String
      prop :value, String
      prop :apply, _Nilable(Proc)
    end

    prop :url, String
    prop :filters, _Array(::Decor::SearchAndFilter::Filter), default: -> { [] }

    prop :search, Search

    prop :download_path, _Nilable(String)

    stimulus do
      actions [:click, :toggle], ["click@window", :hide_on_click_outside],
        [:keydown, :handle_search_input_keydown],
        [:focus, :handle_range_picker],
        [:click, :handle_clear_filters],
        [:click, :handle_apply]
    end

    def actions(&block)
      @actions = block
    end

    def with_actions(&block)
      @actions = block
      self
    end

    def filters(&block)
      @filters_slot = block
    end

    def with_filters(&block)
      @filters_slot = block
      self
    end

    def view_template(&block)
      vanish(&block) if block
      root_element do |el|
        form(method: "get", action: @url) do
          div(class: "sm:flex sm:rounded-md sm:shadow-sm") do
            div(class: "relative flex-grow focus-within:z-10") do
              if @search.present?
                render ::Decor::Forms::TextField.new(
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
                  control_html_options: {class: @filters.present? ? "rounded-md sm:rounded-l-md sm:rounded-r-none pl-10" : "rounded-md"},
                  object: nil,
                  object_name: nil,
                  method_name: nil,
                  validations: nil
                )
              end
            end

            if @filters.present?
              render ::Decor::Dropdown.new(
                position: :right,
                stimulus_outlet_host: el
              ) do |dropdown|
                filters_active = filters_on?
                component_filters = @filters
                dropdown.trigger_button do
                  button(
                    type: "button",
                    class: "-ml-px relative inline-flex items-center px-4 py-2 mt-4 sm:mt-0 w-full sm:w-auto border border-gray-300 text-sm font-medium #{@search.present? ? "rounded-md sm:rounded-r-md sm:rounded-l-none" : "rounded-md"} text-gray-700 bg-white sm:bg-gray-50 hover:bg-gray-100 focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500",
                    data: {**stimulus_actions([:click, :toggle], [:"click@window", :hide_on_click_outside])}
                  ) do
                    render ::Decor::Icon.new(
                      name: "filter",
                      variant: filters_active ? :solid : :outline,
                      html_options: {class: "h-5 w-5 text-gray-400"}
                    )

                    span(class: "ml-auto mr-2 sm:ml-2") { "Filter" }
                    render ::Decor::Icon.new(name: "chevron-down", style: :solid, html_options: {class: "h-5 w-5 text-gray-400"})
                  end
                end

                dropdown.menu_content do
                  div(class: "space-y-2 p-4") do
                    component_filters.each do |filter|
                      case filter.type
                      when :select
                        render ::Decor::Forms::Select.new(
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
                          classes: "pt-2 w-full",
                          stimulus_outlet_host: el
                        )
                      when :checkbox
                        render ::Decor::Forms::Checkbox.new(
                          name: filter.name,
                          label: filter.label,
                          checked: filter.value == "true",
                          disabled: filter.disabled,
                          collapsing_helper_text: true,
                          classes: "pt-2 w-full",
                          stimulus_outlet_host: el
                        )
                      when :date_range
                        render ::Decor::Forms::TextField.new(
                          label_position: :inside,
                          name: filter.name,
                          label: filter.label,
                          value: filter.value,
                          disabled: filter.disabled,
                          collapsing_helper_text: true,
                          control_actions: [
                            stimulus_action(:focus, :handle_range_picker)
                          ],
                          classes: "pt-2 w-full",
                          stimulus_outlet_host: el
                        )
                      end
                    end
                  end

                  div(class: "space-y-4 p-4 border-t border-gray-200") do
                    if filters_active
                      render ::Decor::Button.new(
                        label: "Clear filters",
                        stimulus_targets: [stimulus_target(:clear_filters_button)],
                        stimulus_actions: [stimulus_action(:click, :handle_clear_filters)],
                        icon: "x",
                        size: :small,
                        color: :danger,
                        variant: :outlined,
                        full_width: true
                      )
                    end

                    render ::Decor::Button.new(
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
            div(class: "filters-slot") do
              raw(@filters_slot.call.html_safe)
            end
          end

          if @download_path.present?
            a(
              href: @download_path,
              method: :post,
              class: "w-[38px] h-[38px] flex-shrink-0 grid place-content-center border border-gray-300 rounded-md shadow-sm bg-white hover:bg-gray-50 focus:outline-none",
              data: {confirm: "Do you wish to download the data currently shown in the table?", "confirm-yes": "Yes, download"}
            ) do
              render ::Decor::Icon.new(name: "download", html_options: {class: "h-4 w-4 text-blue-500"})
            end
          end

          if @actions.present?
            div(class: "mt-4 sm:mt-0") do
              raw(@actions.call.html_safe)
            end
          end
        end
      end
    end

    def filters_on?
      @filters.any? { |s| s.value.present? } || @search&.value&.present?
    end

    private

    def root_element_classes
      "sm:flex sm:items-center space-x-0 sm:space-x-4 mt-3 sm:mt-0 sm:ml-4"
    end
  end
end
