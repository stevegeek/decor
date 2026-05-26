require "application_system_test_case"

# Proves the dynamic behaviour of the rich Suite form widgets in a real browser:
# switch toggle, button-radio-group selection, searchable-select (open + filter
# + select), and the date calendar writing into its hidden field.
class DemoSuiteInputsTest < ApplicationSystemTestCase
  SWITCH = "decor--suite--forms--switch"
  SS = "decor--suite--forms--searchable-select"

  test "switch toggles its checkbox" do
    visit demo_suite_inputs_path
    cb = find("[data-#{SWITCH}-target='checkbox']")
    refute cb.checked?, "switch should start off"
    cb.click
    sleep 0.1
    assert cb.checked?, "switch should be on after click"
  end

  test "button radio group checks the clicked option" do
    visit demo_suite_inputs_path
    pro = find("input[name='demo[plan]'][value='pro']", visible: :all)
    refute pro.checked?
    find("label[for='#{pro[:id]}']").click
    sleep 0.1
    assert find("input[name='demo[plan]'][value='pro']", visible: :all).checked?,
      "the Pro option should be selected after clicking it"
  end

  test "searchable select opens, filters as you type, and selects an option" do
    visit demo_suite_inputs_path
    input = find("[data-#{SS}-target='input']")
    input.click
    sleep 0.3

    dropdown = find("[data-#{SS}-target='dropdown']", visible: true, wait: 5)
    assert dropdown.has_text?("United States"), "all choices should show on open"
    assert dropdown.has_text?("Canada")

    input.set("united")
    sleep 0.3
    assert dropdown.has_text?("United States"), "matching choice should remain"
    refute dropdown.has_text?("Canada"), "non-matching choice should be filtered out"

    dropdown.find("[data-result-id]", text: "United States", match: :first).click
    sleep 0.2
    assert_selector "[data-#{SS}-target='selectedLabel']", text: "United States"
    assert_equal "us", page.evaluate_script(%(document.querySelector("[name='demo[country]']")?.value)),
      "selecting should write the chosen id into the hidden input"
  end

  test "date calendar writes the chosen date into the hidden field" do
    visit demo_suite_inputs_path
    page.execute_script(<<~JS)
      var cal = document.querySelector("calendar-date");
      cal.value = "2026-06-15";
      cal.dispatchEvent(new Event("change", { bubbles: true }));
    JS
    sleep 0.2
    assert_equal "2026-06-15", page.evaluate_script(%(document.querySelector("[name='demo[due]']")?.value)),
      "the calendar's change should fill the hidden date field"
  end
end
