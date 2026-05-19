# frozen_string_literal: true

module Decor
  module Suite
    module Forms
      # Suite skin of SearchableMultiSelect — multi-select typeahead with an
      # inline search input, a results dropdown, and a row of chips (one per
      # picked value). Picking adds a chip without closing the dropdown;
      # Backspace on an empty input pops the trailing chip.
      #
      # Visual identity:
      #   - Single suite-control-radius shell with hairline-strong border,
      #     white surface, 3px primary-100 focus halo. Chips wrap inside the
      #     shell alongside the input.
      #   - Dropdown rendered inline (absolute positioning relative to the
      #     shell) — sibling, so it inherits the shell's width.
      #   - Suite-token typography + suite-gray-25 hover row in the dropdown.
      #
      # Shares its Stimulus controller chassis with the single-select cousin —
      # see decor/suite/forms/searchable_multi_select_controller.js for the
      # selection-handling + Backspace-removes-chip overrides.
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
      end
    end
  end
end
