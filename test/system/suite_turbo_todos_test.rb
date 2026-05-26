require "application_system_test_case"

class SuiteTurboTodosSystemTest < ApplicationSystemTestCase
  ERROR_TEXT = "[data-decor--suite--forms--text-field-target='errorText']".freeze

  test "client-side validation blocks the request when title is blank" do
    visit suite_turbo_todos_path

    # Title is blank — click "Create Todo". No confirm modal on this page
    # (no data-turbo-confirm on the submit button), so the Suite form
    # controller runs immediately. It fires performValidation, finds the
    # title field invalid (required + minimum_length 3), calls
    # preventDefault(), and the submit never leaves the browser.
    click_button "Create Todo"

    # The field shows its error caption.
    assert_selector ERROR_TEXT, text: /.+/, wait: 5

    types = event_log
    # Turbo submit never started — the browser submit was intercepted first.
    refute_includes types, "turbo:submit-start"
    assert_equal 0, Todo.count
  end

  test "valid submit fires the Turbo submit lifecycle and morphs the list" do
    visit suite_turbo_todos_path
    assert_selector "#morph-sentinel[data-token]"
    token_before = find("#morph-sentinel")["data-token"]

    fill_in "todo[title]", with: "Renew library card"
    find("select[name='todo[priority]']").find("option[value='high']").select_option
    click_button "Create Todo"

    # Outcome: new row present in the suite-turbo-todos list, still on the index URL.
    assert_selector "#suite-turbo-todos li", text: "Renew library card", wait: 5
    assert_current_path suite_turbo_todos_path
    assert_equal 1, Todo.count

    # Events: the full Turbo submit lifecycle fired.
    types = event_log
    assert_includes types, "turbo:submit-start"
    assert_includes types, "turbo:before-fetch-request"
    assert_includes types, "turbo:before-fetch-response"
    assert_includes types, "turbo:submit-end"
    assert_includes types, "turbo:morph"

    # Morph proof: the permanent sentinel survived with an unchanged token.
    assert_equal token_before, find("#morph-sentinel")["data-token"]
    assert_selector "#event-log li[data-event='turbo:submit-end'][data-success='true']"
  end

  test "server-side rejection (duplicate title) surfaces via #suite-turbo-errors and does not navigate away" do
    visit suite_turbo_todos_path

    # Create first todo through the UI.
    fill_in "todo[title]", with: "Unique suite turbo chore"
    find("select[name='todo[priority]']").find("option[value='low']").select_option
    click_button "Create Todo"
    assert_selector "#suite-turbo-todos li", text: "Unique suite turbo chore", wait: 5
    assert_equal 1, Todo.count

    # Submit the same title again — client-side validation passes (length >= 3),
    # but the server's uniqueness validation rejects it with a 422.
    fill_in "todo[title]", with: "Unique suite turbo chore"
    find("select[name='todo[priority]']").find("option[value='high']").select_option
    click_button "Create Todo"

    assert_selector "#suite-turbo-errors", text: /has already been taken/, wait: 5
    assert_current_path suite_turbo_todos_path
    assert_equal 1, Todo.count # still only the first one

    types = event_log
    assert_includes types, "turbo:submit-start"
    assert_selector "#event-log li[data-event='turbo:submit-end'][data-success='false']"
  end
end
