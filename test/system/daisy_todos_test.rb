require "application_system_test_case"

class DaisyTodosSystemTest < ApplicationSystemTestCase
  include ConfirmModalHelpers

  test "valid submit fires the Turbo submit lifecycle and morphs the list" do
    visit daisy_todos_path
    assert_selector "#morph-sentinel[data-token]"
    token_before = find("#morph-sentinel")["data-token"]

    fill_in "todo[title]", with: "Renew passport"
    # The Daisy select renders with id "todo_priority-control"; the label text
    # includes an asterisk ("Priority *"), so we target the select by name directly.
    find("select[name='todo[priority]']").find("option[value='high']").select_option
    click_button "Create Todo"

    # The confirm modal now gates this submit — click Confirm to proceed.
    click_confirm_positive

    # Outcome: new row present, still on the index URL.
    assert_selector "#daisy-todos li", text: "Renew passport", wait: 5
    assert_current_path daisy_todos_path
    # NOTE: fixtures load in the test-process transaction, which is not visible to
    # the Puma server. The browser starts from 0 records, so after one successful
    # create the DB (seen by both the browser and the test connection outside
    # the fixture transaction) holds exactly 1 record.
    assert_equal 1, Todo.count

    # Events: the submit cycle, then a morph (not a full replace).
    types = event_log
    assert_includes types, "turbo:submit-start"
    assert_includes types, "turbo:before-fetch-request"
    assert_includes types, "turbo:before-fetch-response"
    assert_includes types, "turbo:submit-end"
    assert_includes types, "turbo:morph"

    # Morph proof: the permanent sentinel survived (token unchanged).
    assert_equal token_before, find("#morph-sentinel")["data-token"]
    # And the submit-end recorded success.
    assert_selector "#event-log li[data-event='turbo:submit-end'][data-success='true']"
  end

  test "invalid submit re-renders with a 422 and does not navigate away" do
    visit daisy_todos_path

    # The title field has required: true which emits the HTML5 `required` attribute.
    # We bypass native browser validation via JS so the blank form reaches the server.
    fill_in "todo[title]", with: "" # ensure blank
    page.evaluate_script("document.querySelector('input[name=\"todo[title]\"]').removeAttribute('required')")
    click_button "Create Todo"

    # The confirm modal gates this submit — click Confirm to let the (invalid)
    # form reach the server; the server will respond 422.
    click_confirm_positive

    assert_selector "#daisy-errors", text: /can't be blank/, wait: 5
    assert_current_path daisy_todos_path
    # NOTE: same fixture-isolation reason as the valid-submit test — the browser
    # starts from 0 records and no record is created on a 422, so count stays 0.
    assert_equal 0, Todo.count

    types = event_log
    assert_includes types, "turbo:submit-start"
    assert_selector "#event-log li[data-event='turbo:submit-end'][data-success='false']"
  end
end
