# frozen_string_literal: true

module Decor
  module Daisy
    module Forms
      class SearchableMultiSelect < ::Decor::Components::Forms::SearchableMultiSelect
        def view_template
          root_element do
            if @label.present?
              label(
                for: "#{id}-control",
                class: "decor:d-label decor:block decor:mb-1"
              ) do
                span(class: "decor:d-label-text decor:text-gray-900") { @label }
              end
              if @description.present?
                p(class: "decor:d-label-text-alt decor:text-gray-500 decor:mb-1") { @description }
              end
            end

            div(class: "decor:relative") do
              div(class: shell_classes) do
                child_element(
                  :div,
                  class: "decor:flex decor:flex-wrap decor:gap-1",
                  stimulus_target: :selected_container
                ) do
                  @selected_items.each do |item|
                    render_chip(item)
                  end
                end

                child_element(
                  :input,
                  type: "text",
                  id: "#{id}-control",
                  class: "decor:flex-1 decor:min-w-[120px] decor:border-none decor:outline-hidden decor:focus:ring-0 decor:p-0 decor:bg-transparent decor:text-gray-900 decor:placeholder:text-gray-400",
                  placeholder: @placeholder,
                  autocomplete: "off",
                  disabled: (true if disabled?),
                  stimulus_target: :input,
                  stimulus_actions: [
                    [:input, :search],
                    [:keydown, :handle_keydown],
                    [:focus, :handle_focus],
                    [:click, :handle_input_click],
                    [:blur, :handle_blur]
                  ]
                )
              end

              child_element(
                :div,
                class: "decor:hidden decor:absolute decor:z-50 decor:mt-1 decor:w-full decor:bg-white decor:border decor:border-gray-300 decor:rounded-md decor:shadow-lg decor:max-h-60 decor:overflow-y-auto",
                role: "listbox",
                stimulus_target: :dropdown,
                stimulus_actions: [[:scroll, :handle_dropdown_scroll]]
              )
            end

            div(data: stimulus_target(:hidden_inputs_container).to_h) do
              @selected_items.each do |item|
                input(type: "hidden", name: @name, value: item[:id])
              end
            end
          end
        end

        private

        def root_element_classes
          "decor:w-full"
        end

        def shell_classes
          "decor:w-full decor:rounded-md decor:border decor:border-gray-300 decor:bg-white decor:flex decor:flex-wrap decor:items-center decor:gap-1 decor:px-3 decor:py-2 decor:focus-within:border-primary decor:focus-within:ring-2 decor:focus-within:ring-primary/30"
        end

        def render_chip(item)
          span(
            class: "decor:inline-flex decor:items-center decor:gap-1 decor:rounded-full decor:bg-primary/10 decor:text-primary decor:px-2 decor:py-px decor:text-xs decor:font-medium",
            "data-item-id": item[:id]
          ) do
            span { plain item[:label].to_s }
            child_element(
              :button,
              type: "button",
              class: "decor:text-primary decor:hover:opacity-70 decor:leading-none",
              data: {item_id: item[:id]},
              stimulus_actions: [[:click, :remove_item]]
            ) do
              render ::Decor::Icon.new(name: "x", classes: "decor:h-3 decor:w-3")
            end
          end
        end
      end
    end
  end
end
