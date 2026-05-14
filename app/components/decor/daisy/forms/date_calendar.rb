# frozen_string_literal: true

module Decor
  module Daisy
    module Forms
      class DateCalendar < ::Decor::Components::Forms::DateCalendar
        def view_template
          root_element do |el|
            layout = ::Decor::Daisy::Forms::FormFieldLayout.new(
              **form_field_layout_options(el),
              stimulus_classes: {
                valid_label: @disabled ? "decor:text-disabled" : "decor:text-gray-900",
                invalid_label: "decor:text-error-dark"
              }
            )

            layout.helper_text_section do
              render ::Decor::Daisy::Forms::HelperTextSection.new(
                helper_text: @helper_text,
                error_text: error_text,
                disabled: @disabled,
                error_section: !floating_error_text?,
                collapsing_helper_text: @collapsing_helper_text
              )
            end

            render layout do
              # Hidden input to store the actual form value
              input(
                type: "hidden",
                name: @name,
                value: formatted_value,
                data: {**el.stimulus_target(:hidden_input)}
              )

              # Cally calendar component
              public_send(calendar_element_type, **calendar_attributes(el)) do
                # Navigation icons (slots)
                svg(slot: "previous", class: "decor:w-4 decor:h-4", fill: "none", stroke: "currentColor", viewBox: "0 0 24 24") do |s|
                  s.path(stroke_linecap: "round", stroke_linejoin: "round", stroke_width: "2", d: "M15 19l-7-7 7-7")
                end

                svg(slot: "next", class: "decor:w-4 decor:h-4", fill: "none", stroke: "currentColor", viewBox: "0 0 24 24") do |s|
                  s.path(stroke_linecap: "round", stroke_linejoin: "round", stroke_width: "2", d: "M9 5l7 7-7 7")
                end

                # Calendar month display
                public_send(:calendar_month)
              end

              render ::Decor::Daisy::Forms::ErrorIconSection.new(
                error_text: error_text,
                show_floating_message: floating_error_text?,
                html_options: {
                  class: "#{errors? ? "" : "decor:hidden"} decor:right-3"
                }
              )
            end
          end
        end

        private

        def calendar_attributes(el)
          attrs = {
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
          classes = ["decor:cally", "decor:bg-base-100", "decor:border", "decor:border-base-300", "decor:shadow-lg", "decor:rounded-box"]
          classes << "decor:calendar-error" if errors?
          classes.join(" ")
        end
      end
    end
  end
end
