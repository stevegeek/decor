# frozen_string_literal: true

module Decor
  module Suite
    module Forms
      class Select < ::Decor::Components::Forms::Select
        include ::Phlex::Rails::Helpers::HiddenFieldTag

        # The base Select defines no invalid Stimulus class, so client-side
        # validation had nothing to toggle and the <select> never went red on
        # blur. Add the Suite-danger border the server renders for errors (plus
        # a matching label colour). `label_position: :inside` is already handled
        # by prepending the label as a placeholder <option>, so it needs nothing
        # here.
        stimulus do
          classes(
            invalid_input: "decor:border-suite-danger-500",
            invalid_label: "decor:text-suite-danger-700"
          )
        end

        def view_template
          root_element do
            div(class: container_classes, data: form_field_target_data(:container)) do
              if @label.present? && (label_top? || label_left?)
                label_block
              end

              div(class: input_section_classes) do
                div(class: control_row_classes) do
                  div(class: "decor:relative decor:w-full") do
                    if @multiple
                      hidden_field_tag(multi_select_name, "", id: nil)
                    end

                    child_element(
                      :select,
                      **html_attributes,
                      class: select_classes,
                      data: @control_html_options[:data],
                      stimulus_actions: @control_actions,
                      stimulus_targets: ([:input] + @control_targets).uniq
                    ) do
                      if grouped?
                        grouped_options_for_select(
                          all_options_array,
                          disabled: all_disabled_options,
                          selected: resolve_selected_option
                        )
                      else
                        options_for_select(
                          all_options_array,
                          disabled: all_disabled_options,
                          selected: resolve_selected_option
                        )
                      end
                    end

                    chevron_indicator

                    if !silent_helper_and_error_text?
                      error_icon
                    end
                  end

                  # `:inside` is handled by all_options_array prepending the
                  # label as a placeholder <option> — nothing to render here.
                  if @label.present? && (label_right? || label_inline?)
                    div(class: "decor:ml-4 decor:shrink-0") { label_block }
                  end
                end

                render_helper_or_error_text unless silent_helper_and_error_text?
              end
            end
          end
        end

        private

        def root_element_classes
          [
            "decor--suite--forms--select",
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

        def control_row_classes
          if label_right? || label_inline?
            "decor:flex decor:items-baseline"
          else
            ""
          end
        end

        def label_block
          div(class: label_column_classes) do
            label(
              for: "#{id}-control",
              class: label_text_classes,
              data: form_field_target_data(:label)
            ) { plain label_with_required }
            if @description.present?
              p(class: description_classes) { plain @description }
            end
          end
        end

        def form_field_target_data(target_name)
          stimulus_target(target_name).to_h
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

        def select_classes
          [
            "decor:w-full decor:appearance-none decor:bg-white",
            "decor:cursor-pointer decor:pr-9",
            "decor:suite-input-base",
            "decor:rounded-suite-control decor:border",
            border_classes,
            text_color_class,
            "decor:outline-hidden",
            "decor:transition-[border-color,box-shadow] decor:duration-suite-fast decor:ease-out",
            disabled? ? "decor:cursor-not-allowed decor:opacity-60" : "decor:hover:border-gray-400",
            input_classes
          ].compact.reject { |c| c.to_s.empty? }.join(" ")
        end

        def border_classes
          if errors?
            "decor:border-suite-danger-500 decor:focus:border-suite-danger-500 decor:focus:shadow-[0_0_0_3px_var(--color-suite-danger-100)]"
          else
            "decor:border-suite-hairline-strong decor:focus:border-suite-primary-500 decor:focus:shadow-[0_0_0_3px_var(--color-suite-primary-100)]"
          end
        end

        def text_color_class
          if disabled?
            "decor:text-gray-400"
          elsif errors?
            "decor:text-suite-danger-700"
          else
            "decor:text-gray-900"
          end
        end

        def chevron_indicator
          span(
            class: "decor:pointer-events-none decor:absolute decor:inset-y-0 decor:right-0 decor:flex decor:items-center decor:pr-[14px]",
            aria_hidden: "true"
          ) do
            span(class: chevron_glyph_classes)
          end
        end

        def chevron_glyph_classes
          color = errors? ? "decor:border-suite-danger-500" : "decor:border-gray-500"
          [
            "decor:block decor:w-[6px] decor:h-[6px]",
            "decor:border-r-[1.5px] decor:border-b-[1.5px]",
            color,
            "decor:rotate-45 decor:-translate-y-[35%]"
          ].join(" ")
        end

        # Always rendered so the JS controller has its `errorIcon` target.
        # `decor:hidden` toggles based on initial server-rendered error state.
        def error_icon
          span(
            class: ["decor:pointer-events-none decor:absolute decor:inset-y-0 decor:right-7 decor:flex decor:items-center", errors? ? nil : "decor:hidden"].compact.join(" "),
            aria_hidden: "true",
            data: form_field_target_data(:errorIcon)
          ) do
            render ::Decor::Icon.new(
              name: "exclamation-circle",
              style: :solid,
              html_options: {class: "decor:h-5 decor:w-5 decor:text-suite-danger-500"}
            )
          end
        end

        # Dual paragraph — helperText for the JS controller to swap content
        # into, errorText for the controller to write validation errors.
        def render_helper_or_error_text
          p(
            class: [helper_text_classes(false), (errors? || @helper_text.blank?) ? "decor:hidden" : nil].compact.join(" "),
            data: form_field_target_data(:helperText)
          ) { plain @helper_text.to_s }

          p(
            class: [helper_text_classes(true), errors? ? nil : "decor:hidden"].compact.join(" "),
            data: form_field_target_data(:errorText)
          ) { plain errors? ? error_text : "" }
        end

        def helper_text_classes(error)
          color = error ? "decor:text-suite-danger-700" : "decor:text-gray-500"
          "decor:suite-field-help #{color} decor:mx-0 decor:mb-0"
        end
      end
    end
  end
end
