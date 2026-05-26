require "application_system_test_case"

# End-to-end coverage for Suite form field/layout behaviour on the Turbo page:
#   - client-side validation paints a red outline (not just red text) on blur
#   - the form footer slot (with_actions) positions the submit and still submits
class SuiteFormStatesTest < ApplicationSystemTestCase
  TITLE = "input[name='todo[title]']"

  test "invalid required field gains a red outline (and red error text) on blur" do
    visit suite_turbo_todos_path

    field = find(TITLE)
    field.click
    field.send_keys(:tab) # blur an empty required field
    sleep 0.4

    # Red helper text appears...
    assert_selector "[data-decor--suite--forms--text-field-target='errorText']",
      text: /can't be blank/i, wait: 5

    # ...and the input itself gets the suite-danger red border (the regression:
    # it previously only carried the daisy `invalid:border-error-dark` class,
    # which isn't a compiled Suite utility, so nothing painted).
    has_red_border = page.evaluate_script(
      "/border-suite-danger/.test(document.querySelector(\"#{TITLE}\").className)"
    )
    assert has_red_border,
      "Expected the invalid field to gain a suite-danger red border on blur"
  end

  test "submit sits in a separated footer (with_actions) and still creates a todo" do
    visit suite_turbo_todos_path

    # The submit renders inside a right-aligned footer region, not inline.
    assert_selector "form [class*='justify-end'] button", text: "Create Todo"

    fill_in "Title", with: "Footer submit works"
    click_button "Create Todo"

    assert_selector "table", text: "Footer submit works", wait: 10
  end
end
