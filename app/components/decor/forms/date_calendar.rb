# frozen_string_literal: true

module Decor
  module Forms
    class DateCalendar < FormField
      # Calendar type - single date, range, or multi-select
      prop :calendar_type, _Union(:date, :range, :multi, :month), default: :date

      # Date constraints
      prop :min_date, _Nilable(_Union(Date, Time, DateTime))
      prop :max_date, _Nilable(_Union(Date, Time, DateTime))

      # Display options
      prop :months, Integer, default: 1
      prop :first_day_of_week, _Integer(0..6), default: 0
      prop :locale, String, default: "en-US"

      # Date filtering options
      prop :disabled_dates, _Array(String), default: -> { [] } do |dates|
        dates.map { |date| format_date_for_cally(date) }.compact
      end
      prop :disabled_days_of_week, _Array(Integer), default: -> { [] }
      prop :enabled_dates, _Array(String), default: -> { [] } do |dates|
        dates.map { |date| format_date_for_cally(date) }.compact
      end
      prop :enabled_days_of_week, _Array(Integer), default: -> { (0..6).to_a }

      register_element :calendar_range
      register_element :calendar_multi
      register_element :calendar_date
      register_element :calendar_month

      stimulus do
        values_from_props :calendar_type, :locale, :months, :disabled_dates, :disabled_days_of_week, :enabled_dates, :enabled_days_of_week

        classes invalid_input: "invalid:border-error-dark"
      end

      def view_template
        root_element do |el|
          layout = ::Decor::Forms::FormFieldLayout.new(
            **form_field_layout_options(el),
            stimulus_classes: {
              valid_label: @disabled ? "text-disabled" : "text-gray-900",
              invalid_label: "text-error-dark"
            }
          )

          layout.helper_text_section do
            render ::Decor::Forms::HelperTextSection.new(
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
              data: el.stimulus_target(:hidden_input)
            )

            # Cally calendar component
            public_send(calendar_element_type, **calendar_attributes(el)) do
              # Navigation icons (slots)
              svg(slot: "previous", class: "w-4 h-4", fill: "none", stroke: "currentColor", viewBox: "0 0 24 24") do |s|
                s.path(stroke_linecap: "round", stroke_linejoin: "round", stroke_width: "2", d: "M15 19l-7-7 7-7")
              end

              svg(slot: "next", class: "w-4 h-4", fill: "none", stroke: "currentColor", viewBox: "0 0 24 24") do |s|
                s.path(stroke_linecap: "round", stroke_linejoin: "round", stroke_width: "2", d: "M9 5l7 7-7 7")
              end

              # Calendar month display
              public_send(:calendar_month)
            end

            render ::Decor::Forms::ErrorIconSection.new(
              error_text: error_text,
              show_floating_message: floating_error_text?,
              html_options: {
                class: "#{errors? ? "" : "hidden"} right-3"
              }
            )
          end
        end
      end

      private

      def calendar_element_type
        case @calendar_type
        when :month then :calendar_month
        when :range then :calendar_range
        when :multi then :calendar_multi
        else :calendar_date
        end
      end

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
        classes = ["cally", "bg-base-100", "border", "border-base-300", "shadow-lg", "rounded-box"]
        classes << "calendar-error" if errors?
        classes.join(" ")
      end

      def formatted_value
        return nil unless @value

        case @calendar_type
        when :range
          # For range, value should be in format "start/end"
          if @value.is_a?(Array) && @value.length == 2
            "#{format_date_for_cally(@value[0])}/#{format_date_for_cally(@value[1])}"
          elsif @value.is_a?(String)
            @value
          else
            format_date_for_cally(@value)
          end
        when :multi
          # For multi, value should be space-separated dates
          if @value.is_a?(Array)
            @value.map { |date| format_date_for_cally(date) }.join(" ")
          elsif @value.is_a?(String)
            @value
          else
            format_date_for_cally(@value)
          end
        else
          # Single date
          format_date_for_cally(@value)
        end
      end

      def format_date_for_cally(date)
        return nil unless date

        case date
        when Date
          date.iso8601
        when Time, DateTime
          date.to_date.iso8601
        when String
          date
        else
          date.to_s
        end
      end

      def date_filtering_data_attributes
        {
          "disabled-dates": format_dates_for_cally(@disabled_dates),
          "disabled-days-of-week": @disabled_days_of_week.join(","),
          "enabled-dates": format_dates_for_cally(@enabled_dates),
          "enabled-days-of-week": @enabled_days_of_week.join(",")
        }.compact_blank
      end

      def format_dates_for_cally(dates)
        return nil if dates.blank?

        dates.map { |date| format_date_for_cally(date) }.compact.join(",")
      end

      def mapped_attrs
        {
          calendar_type: @calendar_type,
          locale: @locale,
          months: @months,
          first_day_of_week: @first_day_of_week,
          min_date: format_date_for_cally(@min_date),
          max_date: format_date_for_cally(@max_date),
          disabled_dates: @disabled_dates,
          disabled_days_of_week: @disabled_days_of_week,
          enabled_dates: @enabled_dates,
          enabled_days_of_week: @enabled_days_of_week
        }
      end
    end
  end
end
