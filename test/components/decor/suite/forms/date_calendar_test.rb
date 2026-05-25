# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Forms::DateCalendarTest < ActiveSupport::TestCase
  test "renders root element with suite date-calendar identifier" do
    html = render_component(::Decor::Suite::Forms::DateCalendar.new(name: "d", label: "Date"))
    assert_includes html, "decor--suite--forms--date-calendar"
  end

  test "renders a cally calendar-date element by default" do
    html = render_component(::Decor::Suite::Forms::DateCalendar.new(name: "d", label: "Date"))
    assert_includes html, "<calendar-date"
    assert_includes html, "decor:cally"
  end

  test "calendar_type :range renders a calendar-range element" do
    html = render_component(
      ::Decor::Suite::Forms::DateCalendar.new(name: "d", label: "D", calendar_type: :range)
    )
    assert_includes html, "<calendar-range"
  end

  test "calendar_type :multi renders a calendar-multi element" do
    html = render_component(
      ::Decor::Suite::Forms::DateCalendar.new(name: "d", label: "D", calendar_type: :multi)
    )
    assert_includes html, "<calendar-multi"
  end

  test "renders a hidden input that carries the value into the form" do
    html = render_component(
      ::Decor::Suite::Forms::DateCalendar.new(name: "event_date", label: "D", value: Date.new(2026, 6, 15))
    )
    assert_match(/<input[^>]*type="hidden"[^>]*name="event_date"/, html)
    assert_match(/value="2026-06-15"/, html)
  end

  test "renders the label text with suite-field-label density-aware typography" do
    html = render_component(::Decor::Suite::Forms::DateCalendar.new(name: "d", label: "Event date"))
    assert_includes html, "Event date"
    assert_includes html, "decor:suite-field-label"
  end

  test "required appends an asterisk to the label" do
    html = render_component(
      ::Decor::Suite::Forms::DateCalendar.new(name: "d", label: "Event", required: true)
    )
    assert_includes html, "Event *"
  end

  test "hide_required_asterisk omits the asterisk" do
    html = render_component(
      ::Decor::Suite::Forms::DateCalendar.new(name: "d", label: "Event", required: true, hide_required_asterisk: true)
    )
    refute_includes html, "Event *"
    assert_includes html, "Event"
  end

  test "uses suite tokens for default calendar chrome" do
    html = render_component(::Decor::Suite::Forms::DateCalendar.new(name: "d", label: "D"))
    assert_includes html, "decor:border-suite-hairline-strong"
    assert_includes html, "decor:rounded-suite-card"
    assert_includes html, "decor:bg-white"
  end

  test "focus chrome uses suite-primary-500 + suite-primary-100 ring var" do
    html = render_component(::Decor::Suite::Forms::DateCalendar.new(name: "d", label: "D"))
    assert_includes html, "decor:focus-within:border-suite-primary-500"
    assert_includes html, "var(--color-suite-primary-100)"
  end

  test "uses suite motion tokens (no raw duration-150/200)" do
    html = render_component(::Decor::Suite::Forms::DateCalendar.new(name: "d", label: "D"))
    assert_includes html, "decor:duration-suite-fast"
    refute_includes html, "decor:duration-150"
    refute_includes html, "decor:duration-200"
  end

  test "error state applies suite-danger border + ring var on the calendar" do
    html = render_component(
      ::Decor::Suite::Forms::DateCalendar.new(name: "d", label: "D", error_messages: ["Bad"])
    )
    assert_includes html, "decor:border-suite-danger-500"
    assert_includes html, "var(--color-suite-danger-100)"
    assert_includes html, "Bad"
    assert_includes html, "decor:text-suite-danger-700"
  end

  test "disabled state marks the calendar disabled and applies muted chrome" do
    html = render_component(::Decor::Suite::Forms::DateCalendar.new(name: "d", label: "D", disabled: true))
    # Phlex closes the opening tag with `disabled>` when the attribute is set.
    assert_includes html, "disabled>"
    assert_includes html, "decor:bg-gray-50"
    assert_includes html, "decor:cursor-not-allowed"
    assert_includes html, "decor:text-gray-400"
  end

  test "helper text renders below the calendar with suite-field-help typography" do
    html = render_component(
      ::Decor::Suite::Forms::DateCalendar.new(name: "d", label: "D", helper_text: "Pick a weekday")
    )
    assert_includes html, "Pick a weekday"
    assert_includes html, "decor:suite-field-help"
  end

  test "error text suppresses helper text" do
    html = render_component(
      ::Decor::Suite::Forms::DateCalendar.new(name: "d", label: "D", helper_text: "Help", error_messages: ["Bad"])
    )
    assert_includes html, "Bad"
    refute_includes html, "Help"
  end

  test "min_date and max_date propagate to the calendar element" do
    html = render_component(
      ::Decor::Suite::Forms::DateCalendar.new(
        name: "d", label: "D",
        min_date: Date.new(2026, 1, 1), max_date: Date.new(2026, 12, 31)
      )
    )
    assert_match(/min="2026-01-01"/, html)
    assert_match(/max="2026-12-31"/, html)
  end

  test "locale, months, and first_day_of_week propagate to the calendar" do
    html = render_component(
      ::Decor::Suite::Forms::DateCalendar.new(
        name: "d", label: "D",
        locale: "en-GB", months: 2, first_day_of_week: 1
      )
    )
    assert_match(/locale="en-GB"/, html)
    assert_match(/months="2"/, html)
    # Phlex preserves the camelCase key we hand it; cally normalises internally.
    assert_includes html, "firstDayOfWeek=\"1\""
  end

  test "disabled_dates render as a comma-separated data attribute" do
    html = render_component(
      ::Decor::Suite::Forms::DateCalendar.new(
        name: "d", label: "D",
        disabled_dates: [Date.new(2026, 1, 1), Date.new(2026, 1, 2)]
      )
    )
    assert_includes html, %(data-disabled-dates="2026-01-01,2026-01-02")
  end

  test "disabled_days_of_week render as comma-separated data attribute" do
    html = render_component(
      ::Decor::Suite::Forms::DateCalendar.new(name: "d", label: "D", disabled_days_of_week: [0, 6])
    )
    assert_includes html, %(data-disabled-days-of-week="0,6")
  end

  test "renders previous + next navigation slot SVGs" do
    html = render_component(::Decor::Suite::Forms::DateCalendar.new(name: "d", label: "D"))
    assert_match(/<svg[^>]*slot="previous"/, html)
    assert_match(/<svg[^>]*slot="next"/, html)
  end

  test "renders a calendar-month grid inside the calendar" do
    html = render_component(::Decor::Suite::Forms::DateCalendar.new(name: "d", label: "D"))
    assert_includes html, "<calendar-month"
  end

  test "label left position uses the 180px label column" do
    html = render_component(
      ::Decor::Suite::Forms::DateCalendar.new(name: "d", label: "Event", label_position: :left)
    )
    assert_includes html, "decor:sm:w-[180px]"
  end

  test "description renders below the label" do
    html = render_component(
      ::Decor::Suite::Forms::DateCalendar.new(name: "d", label: "Event", description: "Pick a date")
    )
    assert_includes html, "Pick a date"
  end

  test "silent_helper_and_error_text hides helper and error rendering" do
    html = render_component(
      ::Decor::Suite::Forms::DateCalendar.new(
        name: "d", label: "D",
        helper_text: "Help",
        error_messages: ["Bad"],
        silent_helper_and_error_text: true
      )
    )
    refute_includes html, "Help"
    refute_includes html, ">Bad<"
  end
end
