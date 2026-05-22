# frozen_string_literal: true

module Decor
  module Suite
    module Forms
      class DateCalendar < ::Decor::Components::Forms::DateCalendar
        prop :silent_helper_and_error_text, _Boolean, default: false

        prop :mode, _Union(:inline, :popover), default: :inline

        prop :placeholder, _Nilable(String), default: "Select a date…"

        def view_template
          root_element do |el|
            div(class: container_classes) do
              if @label.present? && (label_top? || label_left?)
                label_block
              end

              div(class: input_section_classes) do
                input(
                  type: "hidden",
                  name: @name,
                  value: formatted_value,
                  data: {**el.stimulus_target(:hidden_input)}
                )

                if popover_mode?
                  render_popover_trigger_and_panel(el)
                else
                  div(class: calendar_wrapper_classes) do
                    render_calendar(el)
                  end
                end

                if !silent_helper_and_error_text? && helper_or_error_text.present?
                  p(class: helper_text_classes) { plain helper_or_error_text }
                end
              end
            end
          end
        end

        private

        def silent_helper_and_error_text?
          @silent_helper_and_error_text
        end

        def root_element_classes
          [
            "decor--suite--forms--date-calendar",
            "decor:w-full",
            disabled? ? "decor:disabled" : nil,
            *grid_span_class
          ].compact.join(" ")
        end

        def container_classes
          if label_left?
            "decor:flex decor:flex-col decor:sm:flex-row decor:sm:items-baseline decor:sm:gap-x-4"
          else
            "decor:flex decor:flex-col decor:suite-field-gap"
          end
        end

        def input_section_classes
          if label_left?
            "decor:sm:flex-1 decor:sm:min-w-0 decor:flex decor:flex-col decor:suite-field-gap"
          else
            ""
          end
        end

        def label_block
          div(class: label_column_classes) do
            label(
              for: "#{id}-control",
              class: label_text_classes
            ) { plain label_with_required }
            if @description.present?
              p(class: description_classes) { plain @description }
            end
          end
        end

        def label_column_classes
          label_left? ? "decor:sm:w-[180px] decor:sm:shrink-0" : ""
        end

        def label_text_classes
          color =
            if errors?
              "decor:text-suite-danger-700"
            elsif disabled?
              "decor:text-gray-400"
            else
              "decor:text-gray-900"
            end
          "decor:block decor:suite-field-label #{color}"
        end

        def description_classes
          "decor:suite-field-help decor:text-gray-500"
        end

        def popover_mode?
          @mode == :popover
        end

        def render_popover_trigger_and_panel(el)
          popover_id = "#{id}-popover"

          div(class: "decor:relative") do
            render_popover_trigger_input(el, popover_id)
            render_popover_panel(el, popover_id)
          end
        end

        def render_popover_trigger_input(el, popover_id)
          # Read-only display input. The hidden input above carries the form
          # value; this one is just chrome that mirrors what the user picked.
          input(
            type: "text",
            id: "#{id}-control",
            readonly: true,
            value: display_value_for_popover,
            placeholder: @placeholder,
            class: popover_trigger_classes,
            aria_haspopup: "dialog",
            aria_expanded: "false",
            data: {
              **el.stimulus_target(:popover_trigger),
              **el.stimulus_action(:click, :open_popover)
            }
          )
        end

        def render_popover_panel(el, popover_id)
          # Native [popover] — browser handles top-layer + light dismiss
          # (click-outside + Escape).
          div(
            id: popover_id,
            popover: "auto",
            class: popover_panel_classes,
            data: {**el.stimulus_target(:popover_panel)}
          ) do
            render_calendar(el)
          end
        end

        def popover_trigger_classes
          [
            "decor:w-full decor:rounded-suite-control",
            "decor:border decor:border-suite-hairline-strong decor:bg-white",
            "decor:suite-input-base decor:cursor-pointer",
            "decor:transition-[border-color,box-shadow] decor:duration-suite-fast decor:ease-out",
            "decor:hover:border-gray-400",
            "decor:focus:border-suite-primary-500 decor:outline-hidden",
            "decor:focus:shadow-[0_0_0_3px_var(--color-suite-primary-100)]",
            errors? ? "decor:border-suite-danger-500" : nil,
            disabled? ? "decor:opacity-60 decor:cursor-not-allowed decor:bg-gray-50" : nil
          ].compact.join(" ")
        end

        # `m-0` clears the UA margin that would otherwise re-center it.
        def popover_panel_classes
          "decor:m-0 decor:p-0 decor:bg-transparent decor:border-0"
        end

        def display_value_for_popover
          return "" unless @value
          formatted_value
        end

        def calendar_wrapper_classes
          "decor:relative decor:inline-block"
        end

        def render_calendar(el)
          public_send(calendar_element_type, **calendar_attributes(el)) do
            svg(
              slot: "previous",
              class: "decor:w-4 decor:h-4 decor:text-gray-500",
              fill: "none",
              stroke: "currentColor",
              viewBox: "0 0 24 24",
              aria_hidden: "true"
            ) do |s|
              s.path(stroke_linecap: "round", stroke_linejoin: "round", stroke_width: "2", d: "M15 19l-7-7 7-7")
            end

            svg(
              slot: "next",
              class: "decor:w-4 decor:h-4 decor:text-gray-500",
              fill: "none",
              stroke: "currentColor",
              viewBox: "0 0 24 24",
              aria_hidden: "true"
            ) do |s|
              s.path(stroke_linecap: "round", stroke_linejoin: "round", stroke_width: "2", d: "M9 5l7 7-7 7")
            end

            public_send(:calendar_month)
          end
        end

        def calendar_attributes(el)
          attrs = {
            id: "#{id}-control",
            class: calendar_classes,
            value: formatted_value,
            locale: @locale,
            months: @months,
            firstDayOfWeek: @first_day_of_week,
            data: {
              **el.stimulus_target(:calendar),
              **el.stimulus_action(:change, :handle_change),
              **date_filtering_data_attributes
            }
          }

          attrs[:min] = format_date_for_cally(@min_date) if @min_date
          attrs[:max] = format_date_for_cally(@max_date) if @max_date
          attrs[:disabled] = true if @disabled

          attrs
        end

        def calendar_classes
          [
            "decor:cally",
            "decor:block decor:w-full",
            "decor:bg-white",
            "decor:rounded-suite-card",
            "decor:border",
            border_classes,
            "decor:p-3",
            "decor:text-gray-900",
            "decor:outline-hidden",
            "decor:transition-[border-color,box-shadow] decor:duration-suite-fast decor:ease-out",
            disabled? ? "decor:cursor-not-allowed decor:opacity-60 decor:bg-gray-50" : nil
          ].compact.join(" ")
        end

        def border_classes
          if errors?
            "decor:border-suite-danger-500 decor:focus-within:border-suite-danger-500 decor:focus-within:shadow-[0_0_0_3px_var(--color-suite-danger-100)]"
          else
            "decor:border-suite-hairline-strong decor:focus-within:border-suite-primary-500 decor:focus-within:shadow-[0_0_0_3px_var(--color-suite-primary-100)]"
          end
        end

        def helper_or_error_text
          errors? ? error_text : @helper_text
        end

        def helper_text_classes
          color = errors? ? "decor:text-suite-danger-700" : "decor:text-gray-500"
          "decor:suite-field-help #{color} decor:mx-0 decor:mb-0"
        end
      end
    end
  end
end
