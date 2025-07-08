# @label DateCalendar
class ::Decor::Forms::DateCalendarPreview < ::Lookbook::Preview
  # DateCalendar
  # -------
  #
  # A calendar component using DaisyUI styling with Cally web components.
  # Supports single date, date range, and multi-date selection.
  #
  # Form field attrs
  # @param name text
  # @param label text
  # @param description text
  # @param compact toggle
  # @param label_position [Symbol] select [~, top, left, right, inline, inside]
  # @param grid_span [Symbol] select [~, span_1, span_2, span_half, span_4, span_5, span_full]
  # @param floating_error_text toggle
  # @param required toggle
  # @param disabled toggle
  # @param helper_text text
  # @param value text
  #
  # DateCalendar attrs:
  # @param calendar_type select [date, range, multi]
  # @param months number
  # @param first_day_of_week select [0, 1, 2, 3, 4, 5, 6]
  # @param locale select [en-US, en-GB, fr-FR, de-DE, es-ES]
  # @param min_date select {{ [nil, Date.new(2024, 1, 1), Date.new(2024, 6, 1)] }}
  # @param max_date select {{ [nil, Date.new(2024, 12, 31), Date.new(2024, 6, 30)] }}
  # @param disabled_dates select {{ [[], [Date.today], [Date.today + 1.day, Date.today + 2.days]] }}
  # @param disabled_days_of_week select {{ [[], [0, 6], [1, 2, 3, 4, 5]] }}
  # @param enabled_dates select {{ [[], [Date.today], [Date.today + 1.day, Date.today + 2.days]] }}
  # @param enabled_days_of_week select {{ [(0..6).to_a, [1, 2, 3, 4, 5], [0, 6]] }}
  def playground(
    name: "date_calendar",
    label: "Select a date:",
    description: nil,
    value: nil,
    required: false,
    disabled: false,
    helper_text: nil,
    hide_label_required_asterisk: false,
    compact: false,
    label_position: :top,
    grid_span: nil,
    floating_error_text: false,
    calendar_type: :date,
    months: 1,
    first_day_of_week: 0,
    locale: "en-US",
    min_date: nil,
    max_date: nil,
    disabled_dates: [],
    disabled_days_of_week: [],
    enabled_dates: [],
    enabled_days_of_week: (0..6).to_a
  )
    render ::Decor::Forms::DateCalendar.new(
      name: name,
      label: label,
      description: description,
      value: value,
      required: required,
      disabled: disabled,
      helper_text: helper_text,
      hide_required_asterisk: hide_label_required_asterisk,
      compact: compact,
      label_position: label_position,
      grid_span: grid_span,
      floating_error_text: floating_error_text,
      calendar_type: calendar_type,
      months: months,
      first_day_of_week: first_day_of_week,
      locale: locale,
      min_date: min_date,
      max_date: max_date,
      disabled_dates: disabled_dates,
      disabled_days_of_week: disabled_days_of_week,
      enabled_dates: enabled_dates,
      enabled_days_of_week: enabled_days_of_week
    )
  end

  # Calendar Types Examples
  # ----------------------
  #
  # Showcase the different calendar types available with DaisyUI Cally styling.
  def calendar_types_examples
    render_with_template
  end
end
