# frozen_string_literal: true

module Decor
  module Daisy
    module Forms
      # Daisy skin of SearchableSelect. Uses daisyUI input chrome for the
      # combobox shell, hairline border, and absolute-positioned dropdown.
      class SearchableSelect < ::Decor::Components::Forms::SearchableSelect
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
                  class: ["decor:flex-1 decor:flex decor:items-center decor:gap-2 decor:cursor-pointer", (selected? ? nil : "decor:hidden")].compact.join(" "),
                  stimulus_target: :selected_display,
                  stimulus_actions: [[:click, :reopen_for_reselect]]
                ) do
                  span(class: "decor:truncate decor:text-gray-900", data: stimulus_target(:selected_label).to_h) do
                    plain @selected_item&.dig(:label).to_s
                  end
                  if @allow_clear
                    child_element(
                      :button,
                      type: "button",
                      class: "decor:ml-auto decor:text-gray-400 decor:hover:text-gray-600 decor:shrink-0",
                      stimulus_actions: [[:click, :clear]]
                    ) do
                      render ::Decor::Icon.new(name: "x", classes: "decor:h-3.5 decor:w-3.5")
                    end
                  end
                end

                child_element(
                  :input,
                  type: "text",
                  id: "#{id}-control",
                  class: [
                    "decor:flex-1 decor:min-w-[120px] decor:border-none decor:outline-hidden decor:focus:ring-0 decor:p-0 decor:bg-transparent decor:text-gray-900 decor:placeholder:text-gray-400",
                    (selected? ? "decor:hidden" : nil)
                  ].compact.join(" "),
                  placeholder: @placeholder,
                  autocomplete: "off",
                  disabled: (true if disabled?),
                  stimulus_target: :input,
                  stimulus_actions: [
                    [:input, :search],
                    [:keydown, :handle_keydown],
                    [:focus, :handle_focus],
                    [:click, :handle_input_click]
                  ]
                )
              end

              child_element(
                :div,
                class: "decor:hidden decor:absolute decor:z-50 decor:mt-1 decor:w-full decor:bg-white decor:border decor:border-gray-300 decor:rounded-md decor:shadow-lg decor:max-h-60 decor:overflow-y-auto",
                stimulus_target: :dropdown,
                stimulus_actions: [[:scroll, :handle_dropdown_scroll]]
              )
            end

            div(data: stimulus_target(:hidden_inputs_container).to_h) do
              if selected?
                input(type: "hidden", name: @name, value: @selected_item[:id])
              end
            end
          end
        end

        private

        def root_element_classes
          "decor:w-full"
        end

        def shell_classes
          "decor:w-full decor:rounded-md decor:border decor:border-gray-300 decor:bg-white decor:flex decor:items-center decor:gap-2 decor:px-3 decor:py-2 decor:focus-within:border-primary decor:focus-within:ring-2 decor:focus-within:ring-primary/30"
        end
      end
    end
  end
end
