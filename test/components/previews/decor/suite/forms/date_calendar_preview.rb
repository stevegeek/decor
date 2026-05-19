# frozen_string_literal: true

# @label DateCalendar
class ::Decor::Suite::Forms::DateCalendarPreview < ::Lookbook::Preview
  # @group Examples

  # @label Default
  def default
    render ::Decor::Suite::Forms::DateCalendar.new(
      name: "appointment_date",
      label: "Appointment date",
      value: Date.today
    )
  end

  # @label Helper text
  def helper_text
    render ::Decor::Suite::Forms::DateCalendar.new(
      name: "appointment_date",
      label: "Appointment date",
      helper_text: "Pick a weekday in the next 30 days."
    )
  end

  # @label Error state
  def errored
    render ::Decor::Suite::Forms::DateCalendar.new(
      name: "appointment_date",
      label: "Appointment date",
      value: Date.today - 10,
      error_messages: ["Past dates are not allowed"]
    )
  end

  # @label Disabled
  def disabled
    render ::Decor::Suite::Forms::DateCalendar.new(
      name: "appointment_date",
      label: "Appointment date",
      value: Date.today,
      disabled: true
    )
  end

  # @label Required
  def required
    render ::Decor::Suite::Forms::DateCalendar.new(
      name: "appointment_date",
      label: "Appointment date",
      required: true
    )
  end

  # @group Calendar types

  # @label Date range
  def date_range
    render ::Decor::Suite::Forms::DateCalendar.new(
      name: "vacation_dates",
      label: "Vacation dates",
      calendar_type: :range,
      value: [Date.today, Date.today + 7],
      helper_text: "Start and end dates."
    )
  end

  # @label Multi-select
  def multi_select
    render ::Decor::Suite::Forms::DateCalendar.new(
      name: "meeting_dates",
      label: "Meeting days",
      calendar_type: :multi,
      value: [Date.today, Date.today + 3, Date.today + 7]
    )
  end

  # @group Constraints

  # @label Min and max
  def constrained_range
    render ::Decor::Suite::Forms::DateCalendar.new(
      name: "appointment_date",
      label: "Appointment date",
      min_date: Date.today,
      max_date: Date.today + 30,
      helper_text: "Available for the next 30 days only."
    )
  end

  # @label Weekdays only
  def weekdays_only
    render ::Decor::Suite::Forms::DateCalendar.new(
      name: "business_date",
      label: "Business date",
      disabled_days_of_week: [0, 6],
      helper_text: "Monday through Friday."
    )
  end

  # @group Display

  # @label Two months
  def multi_month
    render ::Decor::Suite::Forms::DateCalendar.new(
      name: "project_dates",
      label: "Project timeline",
      calendar_type: :range,
      months: 2
    )
  end

  # @group Label positions

  # @label Label left
  def label_left
    render ::Decor::Suite::Forms::DateCalendar.new(
      name: "appointment_date",
      label: "Appointment",
      description: "When should we see you?",
      label_position: :left,
      value: Date.today
    )
  end

  # @group Playground
  # @param label text
  # @param helper_text text
  # @param required toggle
  # @param disabled toggle
  # @param calendar_type [Symbol] select [date, range, multi, month]
  # @param months number
  # @param first_day_of_week [Integer] select [0, 1, 2, 3, 4, 5, 6]
  # @param locale [String] select [en-US, en-GB, fr-FR, de-DE, es-ES]
  # @param label_position [Symbol] select [top, left]
  def playground(
    label: "Pick a date",
    helper_text: nil,
    required: false,
    disabled: false,
    calendar_type: :date,
    months: 1,
    first_day_of_week: 0,
    locale: "en-US",
    label_position: :top
  )
    render ::Decor::Suite::Forms::DateCalendar.new(
      name: "playground",
      label: label,
      helper_text: helper_text,
      required: required,
      disabled: disabled,
      calendar_type: calendar_type,
      months: months,
      first_day_of_week: first_day_of_week,
      locale: locale,
      label_position: label_position
    )
  end
end
