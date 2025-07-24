# @label DateCalendar
#
# A calendar component for date selection with DaisyUI styling and Cally web components.
# Supports single date, date range, and multi-date selection with various configuration options.
class ::Decor::Forms::DateCalendarPreview < ::Lookbook::Preview
  # @group Examples
  # ---------------
  # Key examples demonstrating common use cases

  # Basic single date selection
  def default
    render ::Decor::Forms::DateCalendar.new(
      name: "appointment_date",
      label: "Select Date",
      value: Date.today
    )
  end

  # Date range selection
  def date_range
    render ::Decor::Forms::DateCalendar.new(
      name: "vacation_dates",
      label: "Vacation Dates",
      calendar_type: :range,
      value: [Date.today, Date.today + 7.days],
      helper_text: "Choose your start and end dates"
    )
  end

  # Multiple date selection
  def multi_select
    render ::Decor::Forms::DateCalendar.new(
      name: "meeting_dates",
      label: "Meeting Days",
      calendar_type: :multi,
      value: [Date.today, Date.today + 3.days, Date.today + 7.days],
      helper_text: "Select multiple meeting dates"
    )
  end

  # Date with constraints
  def with_constraints
    render ::Decor::Forms::DateCalendar.new(
      name: "appointment",
      label: "Available Appointments",
      min_date: Date.today,
      max_date: Date.today + 30.days,
      disabled_days_of_week: [0, 6],
      helper_text: "Weekdays only, next 30 days"
    )
  end

  # @group Playground
  # -----------------
  # Interactive playground with all available options
  #
  # @param name text
  # @param label text
  # @param description text
  # @param value text
  # @param size select [sm, md, lg]
  # @param color select [primary, secondary, accent, success, warning, error, info, neutral]
  # @param style select [filled, outlined, ghost]
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
  # @param compact toggle
  # @param label_position [Symbol] select [~, top, left, right, inline, inside]
  # @param grid_span [Symbol] select [~, span_1, span_2, span_half, span_4, span_5, span_full]
  # @param floating_error_text toggle
  # @param required toggle
  # @param disabled toggle
  # @param helper_text text
  def playground(
    name: "date_calendar",
    label: "Select a date:",
    description: nil,
    value: nil,
    size: :md,
    color: :primary,
    style: :filled,
    calendar_type: :date,
    months: 1,
    first_day_of_week: 0,
    locale: "en-US",
    min_date: nil,
    max_date: nil,
    disabled_dates: [],
    disabled_days_of_week: [],
    enabled_dates: [],
    enabled_days_of_week: (0..6).to_a,
    required: false,
    disabled: false,
    helper_text: nil,
    compact: false,
    label_position: :top,
    grid_span: nil,
    floating_error_text: false
  )
    render ::Decor::Forms::DateCalendar.new(
      name: name,
      label: label,
      description: description,
      value: value,
      size: size,
      color: color,
      style: style,
      calendar_type: calendar_type,
      months: months,
      first_day_of_week: first_day_of_week,
      locale: locale,
      min_date: min_date,
      max_date: max_date,
      disabled_dates: disabled_dates,
      disabled_days_of_week: disabled_days_of_week,
      enabled_dates: enabled_dates,
      enabled_days_of_week: enabled_days_of_week,
      required: required,
      disabled: disabled,
      helper_text: helper_text,
      hide_required_asterisk: false,
      compact: compact,
      label_position: label_position,
      grid_span: grid_span,
      floating_error_text: floating_error_text
    )
  end

  # @group Calendar Types
  # --------------------
  # Different calendar selection modes

  # Single date selection
  def type_single
    render ::Decor::Forms::DateCalendar.new(
      name: "single_date",
      label: "Event Date",
      calendar_type: :date,
      value: Date.today,
      helper_text: "Choose a single date"
    )
  end

  # Date range selection
  def type_range
    render ::Decor::Forms::DateCalendar.new(
      name: "date_range",
      label: "Trip Dates",
      calendar_type: :range,
      value: [Date.today, Date.today + 7.days],
      helper_text: "Choose start and end dates"
    )
  end

  # Multiple dates selection
  def type_multi
    render ::Decor::Forms::DateCalendar.new(
      name: "multiple_dates",
      label: "Meeting Days",
      calendar_type: :multi,
      value: [Date.today, Date.today + 3.days, Date.today + 7.days],
      helper_text: "Choose multiple dates"
    )
  end

  # @group Display Options
  # ---------------------
  # Calendar display configurations

  # Multi-month display
  def multi_month
    render ::Decor::Forms::DateCalendar.new(
      name: "multi_month",
      label: "Project Timeline",
      calendar_type: :range,
      months: 2,
      helper_text: "View two months simultaneously"
    )
  end

  # Three month display
  def three_months
    render ::Decor::Forms::DateCalendar.new(
      name: "quarter_view",
      label: "Quarterly View",
      months: 3,
      helper_text: "View three months at once"
    )
  end

  # @group Constraints
  # -----------------
  # Date selection constraints and restrictions

  # Min/max date range
  def constrained_range
    render ::Decor::Forms::DateCalendar.new(
      name: "constrained_date",
      label: "Appointment Date",
      min_date: Date.today,
      max_date: Date.today + 30.days,
      helper_text: "Available for next 30 days only"
    )
  end

  # Weekdays only
  def weekdays_only
    render ::Decor::Forms::DateCalendar.new(
      name: "weekday_only",
      label: "Business Date",
      disabled_days_of_week: [0, 6],
      helper_text: "Monday through Friday only"
    )
  end

  # Specific disabled dates
  def disabled_dates
    render ::Decor::Forms::DateCalendar.new(
      name: "holiday_blocked",
      label: "Delivery Date",
      disabled_dates: [Date.today + 1.day, Date.today + 2.days, Date.today + 5.days],
      helper_text: "Some dates unavailable due to holidays"
    )
  end

  # @group Localization
  # ------------------
  # Locale and regional settings

  # US format (Sunday first)
  def locale_us
    render ::Decor::Forms::DateCalendar.new(
      name: "us_calendar",
      label: "Date (US)",
      locale: "en-US",
      first_day_of_week: 0,
      value: Date.today
    )
  end

  # UK format (Monday first)
  def locale_uk
    render ::Decor::Forms::DateCalendar.new(
      name: "uk_calendar",
      label: "Date (UK)",
      locale: "en-GB",
      first_day_of_week: 1,
      value: Date.today
    )
  end

  # French format
  def locale_french
    render ::Decor::Forms::DateCalendar.new(
      name: "fr_calendar",
      label: "Date (FR)",
      locale: "fr-FR",
      first_day_of_week: 1,
      value: Date.today
    )
  end

  # @group States
  # ------------
  # Form field states

  # Required field
  def state_required
    render ::Decor::Forms::DateCalendar.new(
      name: "required_date",
      label: "Required Date",
      required: true,
      helper_text: "This field is required"
    )
  end

  # Disabled field
  def state_disabled
    render ::Decor::Forms::DateCalendar.new(
      name: "disabled_date",
      label: "Disabled Date",
      disabled: true,
      value: Date.today,
      helper_text: "This calendar is disabled"
    )
  end

  # With error
  def state_error
    render ::Decor::Forms::DateCalendar.new(
      name: "error_date",
      label: "Date with Error",
      value: Date.today - 10.days,
      min_date: Date.today,
      helper_text: "Past dates not allowed",
      color: :error
    )
  end

  # @group Sizes
  # -----------
  # Different calendar sizes

  # Small size
  def size_small
    render ::Decor::Forms::DateCalendar.new(
      name: "small_calendar",
      label: "Small Calendar",
      size: :sm,
      value: Date.today
    )
  end

  # Medium size (default)
  def size_medium
    render ::Decor::Forms::DateCalendar.new(
      name: "medium_calendar",
      label: "Medium Calendar",
      size: :md,
      value: Date.today
    )
  end

  # Large size
  def size_large
    render ::Decor::Forms::DateCalendar.new(
      name: "large_calendar",
      label: "Large Calendar",
      size: :lg,
      value: Date.today
    )
  end

  # @group Colors
  # ------------
  # Calendar color variants

  # Primary color
  def color_primary
    render ::Decor::Forms::DateCalendar.new(
      name: "primary_calendar",
      label: "Primary Calendar",
      color: :primary,
      value: Date.today
    )
  end

  # Secondary color
  def color_secondary
    render ::Decor::Forms::DateCalendar.new(
      name: "secondary_calendar",
      label: "Secondary Calendar",
      color: :secondary,
      value: Date.today
    )
  end

  # Accent color
  def color_accent
    render ::Decor::Forms::DateCalendar.new(
      name: "accent_calendar",
      label: "Accent Calendar",
      color: :accent,
      value: Date.today
    )
  end

  # @group Styles
  # ------------
  # Calendar style variants

  # Filled style
  def style_filled
    render ::Decor::Forms::DateCalendar.new(
      name: "filled_style",
      label: "Filled Style",
      style: :filled,
      value: Date.today
    )
  end

  # Outlined style
  def style_outlined
    render ::Decor::Forms::DateCalendar.new(
      name: "outlined_style",
      label: "Outlined Style",
      style: :outlined,
      value: Date.today
    )
  end

  # Ghost style
  def style_ghost
    render ::Decor::Forms::DateCalendar.new(
      name: "ghost_style",
      label: "Ghost Style",
      style: :ghost,
      value: Date.today
    )
  end

  # @group Label Positions
  # ---------------------
  # Different label positioning options

  # Top label (default)
  def label_top
    render ::Decor::Forms::DateCalendar.new(
      name: "top_label",
      label: "Top Label",
      label_position: :top,
      value: Date.today
    )
  end

  # Left label
  def label_left
    render ::Decor::Forms::DateCalendar.new(
      name: "left_label",
      label: "Left Label",
      label_position: :left,
      value: Date.today
    )
  end

  # Inline label
  def label_inline
    render ::Decor::Forms::DateCalendar.new(
      name: "inline_label",
      label: "Inline Label",
      label_position: :inline,
      value: Date.today
    )
  end
end
