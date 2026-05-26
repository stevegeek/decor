require "application_system_test_case"

class SuiteTodosSystemTest < ApplicationSystemTestCase
  ERROR_TEXT = "[data-decor--suite--forms--text-field-target='errorText']".freeze

  test "client-side validation blocks the request when title is blank" do
    visit suite_todos_path
    click_button "Create Todo" # title blank => fails the Suite JS validator

    # The field shows its error caption and the request never left the browser.
    assert_selector ERROR_TEXT, text: /.+/, wait: 5
    types = event_log
    assert_includes types, "ajax:stopped"  # rails-ujs aborted after preventDefault
    refute_includes types, "ajax:send"     # request was never sent
    assert_equal 0, Todo.count             # nothing created
  end

  test "valid submit performs the full UJS ajax round-trip and appends the row" do
    visit suite_todos_path

    fill_in "todo[title]", with: "Book dentist"
    find("select[name='todo[priority]']").find("option[value='medium']").select_option
    click_button "Create Todo"

    # Outcome: the created row was appended by the UJS success handler.
    assert_selector "#suite-todos li", text: "Book dentist", wait: 5
    assert_equal 1, Todo.count

    types = event_log
    assert_includes types, "ajax:before"
    assert_includes types, "ajax:beforeSend"
    assert_includes types, "ajax:send"
    assert_includes types, "ajax:success"
    assert_includes types, "ajax:complete"
    refute_includes types, "turbo:submit-start" # Turbo did not handle it
  end

  test "server-side rejection surfaces via ajax:error" do
    visit suite_todos_path

    # Create a todo through the UI first (no fixtures are visible), then submit
    # the SAME title again — the server-only uniqueness validation rejects it.
    fill_in "todo[title]", with: "Unique chore"
    find("select[name='todo[priority]']").find("option[value='low']").select_option
    click_button "Create Todo"
    assert_selector "#suite-todos li", text: "Unique chore", wait: 5
    assert_equal 1, Todo.count

    fill_in "todo[title]", with: "Unique chore" # duplicate => server uniqueness failure
    find("select[name='todo[priority]']").find("option[value='high']").select_option
    click_button "Create Todo"

    assert_selector "#suite-errors", text: /has already been taken/, wait: 5
    types = event_log
    assert_includes types, "ajax:send"
    assert_includes types, "ajax:error"
    assert_equal 1, Todo.count # still only the first one
  end
end
