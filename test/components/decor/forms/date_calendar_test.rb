require "test_helper"

class Decor::Forms::DateCalendarTest < ActiveSupport::TestCase
  test "renders successfully with required attributes" do
    component = Decor::Forms::DateCalendar.new(
      name: "event_date",
      label: "Event Date"
    )
    rendered = render_component(component)

    assert_includes rendered, "calendar-date"
    assert_includes rendered, "cally"
  end

  test "renders with single date calendar by default" do
    component = Decor::Forms::DateCalendar.new(
      name: "event_date",
      label: "Event Date"
    )
    fragment = render_fragment(component)

    calendar = fragment.at_css('calendar-date')
    assert_not_nil calendar
    assert_includes calendar["class"], "cally"
  end

  test "renders with range calendar when calendar_type is range" do
    component = Decor::Forms::DateCalendar.new(
      name: "date_range",
      label: "Date Range",
      calendar_type: :range
    )
    fragment = render_fragment(component)

    calendar = fragment.at_css('calendar-range')
    assert_not_nil calendar
  end

  test "renders with multi calendar when calendar_type is multi" do
    component = Decor::Forms::DateCalendar.new(
      name: "multiple_dates",
      label: "Multiple Dates",
      calendar_type: :multi
    )
    fragment = render_fragment(component)

    calendar = fragment.at_css('calendar-multi')
    assert_not_nil calendar
  end

  test "supports date value" do
    component = Decor::Forms::DateCalendar.new(
      name: "event_date",
      label: "Event Date",
      value: Date.new(2024, 6, 15)
    )
    fragment = render_fragment(component)

    calendar = fragment.at_css('calendar-date')
    assert_equal "2024-06-15", calendar["value"]
  end

  test "renders with DaisyUI calendar classes" do
    component = Decor::Forms::DateCalendar.new(
      name: "event_date",
      label: "Event Date"
    )
    fragment = render_fragment(component)

    calendar = fragment.at_css('calendar-date')
    assert_includes calendar["class"], "cally"
    assert_includes calendar["class"], "bg-base-100"
    assert_includes calendar["class"], "border"
    assert_includes calendar["class"], "rounded-box"
  end

  test "supports custom min and max dates" do
    component = Decor::Forms::DateCalendar.new(
      name: "event_date",
      label: "Event Date",
      min_date: Date.new(2024, 1, 1),
      max_date: Date.new(2024, 12, 31)
    )
    fragment = render_fragment(component)

    calendar = fragment.at_css('calendar-date')
    assert_equal "2024-01-01", calendar["min"]
    assert_equal "2024-12-31", calendar["max"]
  end

  test "supports locale configuration" do
    component = Decor::Forms::DateCalendar.new(
      name: "event_date",
      label: "Event Date",
      locale: "en-GB"
    )
    fragment = render_fragment(component)

    calendar = fragment.at_css('calendar-date')
    assert_equal "en-GB", calendar["locale"]
  end

  test "supports multiple months display" do
    component = Decor::Forms::DateCalendar.new(
      name: "event_date",
      label: "Event Date",
      months: 2
    )
    fragment = render_fragment(component)

    calendar = fragment.at_css('calendar-date')
    assert_equal "2", calendar["months"]
  end

  test "supports first day of week configuration" do
    component = Decor::Forms::DateCalendar.new(
      name: "event_date",
      label: "Event Date",
      first_day_of_week: 1
    )
    fragment = render_fragment(component)

    calendar = fragment.at_css('calendar-date')
    assert_equal "1", calendar["firstdayofweek"]
  end

  test "component inherits from FormField" do
    component = Decor::Forms::DateCalendar.new(
      name: "event_date",
      label: "Event Date"
    )

    assert component.is_a?(Decor::Forms::FormField)
  end

  test "renders with hidden input for form submission" do
    component = Decor::Forms::DateCalendar.new(
      name: "event_date",
      label: "Event Date",
      value: Date.new(2024, 6, 15)
    )
    fragment = render_fragment(component)

    hidden_input = fragment.at_css('input[type="hidden"]')
    assert_not_nil hidden_input
    assert_equal "event_date", hidden_input["name"]
    assert_equal "2024-06-15", hidden_input["value"]
  end

  test "supports disabled state" do
    component = Decor::Forms::DateCalendar.new(
      name: "event_date",
      label: "Event Date",
      disabled: true
    )
    fragment = render_fragment(component)

    calendar = fragment.at_css('calendar-date')
    assert calendar.has_attribute?("disabled")
  end

  test "renders with form field layout structure" do
    component = Decor::Forms::DateCalendar.new(
      name: "event_date",
      label: "Event Date"
    )
    rendered = render_component(component)

    assert_includes rendered, "Event Date"
    assert_includes rendered, "calendar-date"
  end

  test "supports helper text" do
    component = Decor::Forms::DateCalendar.new(
      name: "event_date",
      label: "Event Date",
      helper_text: "Select the date for your event"
    )
    rendered = render_component(component)

    assert_includes rendered, "Select the date for your event"
  end

  test "renders navigation icons" do
    component = Decor::Forms::DateCalendar.new(
      name: "event_date",
      label: "Event Date"
    )
    fragment = render_fragment(component)

    prev_svg = fragment.at_css('svg[slot="previous"]')
    next_svg = fragment.at_css('svg[slot="next"]')
    
    assert_not_nil prev_svg
    assert_not_nil next_svg
  end

  test "renders calendar-month element" do
    component = Decor::Forms::DateCalendar.new(
      name: "event_date",
      label: "Event Date"
    )
    fragment = render_fragment(component)

    calendar_month = fragment.at_css('calendar-month')
    assert_not_nil calendar_month
  end

  test "supports range date values" do
    component = Decor::Forms::DateCalendar.new(
      name: "date_range",
      label: "Date Range",
      calendar_type: :range,
      value: [Date.new(2024, 6, 1), Date.new(2024, 6, 15)]
    )
    fragment = render_fragment(component)

    calendar = fragment.at_css('calendar-range')
    assert_equal "2024-06-01/2024-06-15", calendar["value"]
  end

  test "supports multi date values" do
    component = Decor::Forms::DateCalendar.new(
      name: "multiple_dates",
      label: "Multiple Dates",
      calendar_type: :multi,
      value: [Date.new(2024, 6, 1), Date.new(2024, 6, 15), Date.new(2024, 6, 30)]
    )
    fragment = render_fragment(component)

    calendar = fragment.at_css('calendar-multi')
    assert_equal "2024-06-01 2024-06-15 2024-06-30", calendar["value"]
  end

  test "includes error styling when errors present" do
    component = Decor::Forms::DateCalendar.new(
      name: "event_date",
      label: "Event Date"
    )
    component.instance_variable_set(:@errors, ["Date is required"])
    fragment = render_fragment(component)

    calendar = fragment.at_css('calendar-date')
    assert_includes calendar["class"], "calendar-error"
  end

  test "supports disabled dates" do
    disabled_dates = [Date.today, Date.today + 1.day]
    component = Decor::Forms::DateCalendar.new(
      name: "event_date",
      label: "Event Date",
      disabled_dates: disabled_dates
    )
    fragment = render_fragment(component)

    calendar = fragment.at_css('calendar-date')
    expected_dates = disabled_dates.map(&:iso8601).join(",")
    assert_equal expected_dates, calendar["data-disabled-dates"]
  end

  test "supports disabled days of week" do
    component = Decor::Forms::DateCalendar.new(
      name: "event_date",
      label: "Event Date",
      disabled_days_of_week: [0, 6]
    )
    fragment = render_fragment(component)

    calendar = fragment.at_css('calendar-date')
    assert_equal "0,6", calendar["data-disabled-days-of-week"]
  end

  test "supports enabled dates" do
    enabled_dates = [Date.today + 7.days, Date.today + 14.days]
    component = Decor::Forms::DateCalendar.new(
      name: "event_date",
      label: "Event Date",
      enabled_dates: enabled_dates
    )
    fragment = render_fragment(component)

    calendar = fragment.at_css('calendar-date')
    expected_dates = enabled_dates.map(&:iso8601).join(",")
    assert_equal expected_dates, calendar["data-enabled-dates"]
  end

  test "supports enabled days of week" do
    component = Decor::Forms::DateCalendar.new(
      name: "event_date",
      label: "Event Date",
      enabled_days_of_week: [1, 2, 3, 4, 5]
    )
    fragment = render_fragment(component)

    calendar = fragment.at_css('calendar-date')
    assert_equal "1,2,3,4,5", calendar["data-enabled-days-of-week"]
  end

  test "handles empty date filtering arrays" do
    component = Decor::Forms::DateCalendar.new(
      name: "event_date",
      label: "Event Date",
      disabled_dates: [],
      disabled_days_of_week: []
    )
    fragment = render_fragment(component)

    calendar = fragment.at_css('calendar-date')
    assert_nil calendar["data-disabled-dates"]
    assert_nil calendar["data-disabled-days-of-week"]
  end
end
