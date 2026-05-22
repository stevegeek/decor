# frozen_string_literal: true

module Decor
  module Suite
    module Forms
      class SearchableMultiSelect < ::Decor::Components::Forms::SearchableMultiSelect
        def view_template
          root_element do
            render_label_section if @label.present?

            div(class: "decor:relative decor:w-full") do
              div(class: shell_classes) do
                child_element(
                  :div,
                  class: "decor:flex decor:flex-wrap decor:gap-1",
                  stimulus_target: :selected_container
                ) do
                  @selected_items.each { |item| render_chip(item) }
                end

                render_search_input
              end

              child_element(
                :div,
                class: dropdown_classes,
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

            render_helper_or_error_text
          end
        end

        private

        def root_element_classes
          "decor:w-full"
        end

        def render_label_section
          label(
            for: "#{id}-control",
            class: "decor:suite-field-label decor:text-gray-900 decor:block decor:mb-1"
          ) do
            plain @label
          end
          if @description.present?
            p(class: "decor:suite-field-help decor:text-gray-500 decor:mb-1.5") do
              plain @description
            end
          end
        end

        def render_search_input
          child_element(
            :input,
            type: "text",
            id: "#{id}-control",
            class: input_classes,
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

        def render_chip(item)
          span(
            class: chip_classes,
            "data-item-id": item[:id]
          ) do
            span(class: "decor:suite-body decor:text-suite-primary-700") { plain item[:label].to_s }
            child_element(
              :button,
              type: "button",
              class: chip_dismiss_classes,
              data: {item_id: item[:id]},
              stimulus_actions: [[:click, :remove_item]]
            ) do
              render_dismiss_icon
            end
          end
        end

        def shell_classes
          [
            "decor:w-full decor:rounded-suite-control",
            "decor:border decor:border-suite-hairline-strong decor:bg-white",
            "decor:flex decor:flex-wrap decor:items-center decor:gap-1 decor:suite-input-base",
            "decor:transition-[border-color,box-shadow] decor:duration-suite-fast decor:ease-out",
            "decor:hover:border-gray-400",
            "decor:focus-within:border-suite-primary-500",
            "decor:focus-within:shadow-[0_0_0_3px_var(--color-suite-primary-100)]",
            disabled? ? "decor:opacity-60 decor:cursor-not-allowed" : nil
          ].compact.join(" ")
        end

        def input_classes
          # Borderless input — shell owns padding/font-size via
          # decor:suite-input-base. Input matches font-size so chips and the
          # input baseline align across the same row.
          "decor:flex-1 decor:min-w-[120px] decor:border-none decor:outline-hidden " \
            "decor:focus:ring-0 decor:p-0 decor:bg-transparent " \
            "decor:text-[length:var(--suite-input-font)] decor:leading-[1.4] " \
            "decor:text-gray-900 decor:placeholder:text-gray-400"
        end

        def chip_classes
          "decor:inline-flex decor:items-center decor:gap-1 decor:rounded-full " \
            "decor:bg-suite-primary-50 decor:px-2 decor:py-px " \
            "decor:suite-description decor:font-medium"
        end

        def chip_dismiss_classes
          "decor:text-suite-primary-600 decor:hover:text-suite-primary-700 " \
            "decor:leading-none decor:transition-colors decor:duration-suite-fast"
        end

        def dropdown_classes
          "decor:hidden decor:absolute decor:z-50 decor:mt-1 decor:w-full " \
            "decor:bg-white decor:border decor:border-suite-hairline-strong " \
            "decor:rounded-suite-control decor:shadow-suite-popover " \
            "decor:max-h-60 decor:overflow-y-auto"
        end

        def render_dismiss_icon
          raw safe(<<~SVG)
            <svg xmlns="http://www.w3.org/2000/svg" class="decor:h-3 decor:w-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
              <path d="M18 6L6 18M6 6l12 12"/>
            </svg>
          SVG
        end

        # Dual paragraph — both rendered (hidden when empty) so the
        # FormField JS controller has stable `helperText` / `errorText`
        # targets to swap content into.
        def render_helper_or_error_text
          div(class: "decor:suite-field-help decor:min-h-[1lh]") do
            p(
              class: ["decor:suite-field-help decor:text-gray-500 decor:mx-0 decor:mb-0", (errors? || @helper_text.blank?) ? "decor:hidden" : nil].compact.join(" "),
              data: stimulus_target(:helperText).to_h
            ) { plain @helper_text.to_s }

            p(
              class: ["decor:suite-field-help decor:text-suite-danger-500 decor:mx-0 decor:mb-0", errors? ? nil : "decor:hidden"].compact.join(" "),
              data: stimulus_target(:errorText).to_h
            ) { plain errors? ? error_text : "" }
          end
        end
      end
    end
  end
end
