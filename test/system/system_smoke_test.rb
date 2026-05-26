require "application_system_test_case"

class SystemSmokeTest < ApplicationSystemTestCase
  test "daisy index boots: assets load, Stimulus + event-logger connect" do
    visit daisy_todos_path

    assert_text "Daisy Todos"
    assert_selector "#instrument[data-controller='event-logger']"
    # event-logger stamped the permanent sentinel on connect.
    assert_selector "#morph-sentinel[data-token]"
    # turbo:load fires before the event-logger Stimulus controller binds its
    # document listeners on the initial page visit, so we can't assert it here.
    # The turbo:load / event-sequence assertions belong to Task 7 where they
    # follow a form submit (controller is already connected by then).
    # Instead confirm we landed on the right URL.
    assert_current_path daisy_todos_path
  end
end
