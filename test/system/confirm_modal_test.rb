require "application_system_test_case"

class ConfirmModalDaisyTest < ApplicationSystemTestCase
  include ConfirmModalHelpers

  # Daisy (Turbo Drive) — data-turbo-confirm on submit, Promise-based confirm.

  test "cancel aborts the submit — no todo created, stays on page" do
    visit daisy_todos_path

    fill_in "todo[title]", with: "Confirm cancel test #{SecureRandom.hex(4)}"
    count_before = Todo.count
    click_button "Create Todo"

    # The confirm modal should appear (our wiring reveals it).
    assert_confirm_modal_visible

    # Click Cancel — the Promise resolves to false, Turbo aborts the submit.
    click_confirm_negative

    # No record created; still on the index page.
    assert_equal count_before, Todo.count
    assert_current_path daisy_todos_path

    # No submit events fired: Turbo never sent the request.
    types = event_log
    refute_includes types, "turbo:submit-start"
    refute_includes types, "turbo:before-fetch-request"
  end

  test "confirm proceeds — todo is created and row appears" do
    visit daisy_todos_path

    title = "Confirm proceed test #{SecureRandom.hex(4)}"
    fill_in "todo[title]", with: title
    find("select[name='todo[priority]']").find("option[value='medium']").select_option
    click_button "Create Todo"

    assert_confirm_modal_visible
    click_confirm_positive

    # Turbo submits → morph appends the row.
    assert_selector "#daisy-todos li", text: title, wait: 10
    assert_equal 1, Todo.count
    assert_current_path daisy_todos_path
  end
end

class ConfirmModalSuiteTest < ApplicationSystemTestCase
  include ConfirmModalHelpers

  # Suite (UJS / rails-ujs) — data-confirm on submit button, synchronous
  # Rails.confirm with re-trigger workaround.

  test "cancel aborts the submit — no todo created, stays on page" do
    visit suite_todos_path

    fill_in "todo[title]", with: "Suite cancel test #{SecureRandom.hex(4)}"
    count_before = Todo.count
    click_button "Create Todo"

    # The confirm modal should appear.
    assert_confirm_modal_visible

    # Click Cancel — our override returns false; re-trigger never happens.
    click_confirm_negative

    assert_equal count_before, Todo.count
    assert_current_path suite_todos_path

    # No ajax request was initiated.
    types = event_log
    refute_includes types, "ajax:send"
  end

  test "confirm proceeds — todo is created and row appears via ajax" do
    visit suite_todos_path

    title = "Suite proceed test #{SecureRandom.hex(4)}"
    fill_in "todo[title]", with: title
    find("select[name='todo[priority]']").find("option[value='high']").select_option
    click_button "Create Todo"

    assert_confirm_modal_visible
    click_confirm_positive

    # UJS ajax round-trip appends the row.
    assert_selector "#suite-todos li", text: title, wait: 10
    assert_equal 1, Todo.count
  end
end
