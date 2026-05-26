require "application_system_test_case"

class BulkActionsTest < ApplicationSystemTestCase
  SUITE_MODAL_CTRL = "decor--suite--modals--modal"
  BULK_MODAL_SELECTOR = "[data-controller='#{SUITE_MODAL_CTRL}'][id$='-bulk-modal']"
  BULK_BAR_SELECTOR = "[data-controller='decor--suite--tables--bulk-actions-bar']"

  setup do
    # Seed three todos with distinct priorities so we can verify the update.
    @todo1 = Todo.create!(title: "Buy milk", priority: "low")
    @todo2 = Todo.create!(title: "Walk dog", priority: "low")
    @todo3 = Todo.create!(title: "Read book", priority: "medium")
  end

  test "DataTable renders todos as rows with checkboxes" do
    visit suite_turbo_todos_table_path

    # Each todo title should appear in the table.
    assert_selector "table tbody tr", minimum: 3
    assert_selector "table", text: "Buy milk"
    assert_selector "table", text: "Walk dog"
    assert_selector "table", text: "Read book"

    # Row-selection checkboxes are present (rendered by DataTableRow#view_template
    # when selectable_as? is true).
    assert_selector "input[type='checkbox'][name^='todo_ids_']", minimum: 3
  end

  test "BulkActionsBar is hidden until rows are selected" do
    visit suite_turbo_todos_table_path

    # The BulkActionsBar is hidden by default (style="display: none;").
    assert_selector BULK_BAR_SELECTOR, visible: :hidden

    # Select the first row's checkbox.
    first("input[type='checkbox'][name^='todo_ids_']").click

    # Wait for JS to show the bar (150ms debounce + async).
    sleep 0.5

    # Bar should now be visible.
    assert_selector BULK_BAR_SELECTOR, visible: true, wait: 5
  end

  test "selecting rows and triggering bulk action opens modal with priority form" do
    visit suite_turbo_todos_table_path

    # Select two rows.
    checkboxes = all("input[type='checkbox'][name^='todo_ids_']")
    checkboxes[0].click
    checkboxes[1].click

    sleep 0.5

    # BulkActionsBar becomes visible.
    assert_selector BULK_BAR_SELECTOR, visible: true, wait: 5

    # Click the "Set Priority" bulk action button.
    within BULK_BAR_SELECTOR do
      find("button[data-modal='true']", text: /Set Priority/i).click
    end

    # The Suite Modal should open (has [open] attribute when shown via showModal()).
    assert_selector "#{BULK_MODAL_SELECTOR}[open]", wait: 10

    # The modal body should contain the priority form (loaded from content_href).
    within "#{BULK_MODAL_SELECTOR}[open]" do
      assert_selector "select#bulk_priority_select", wait: 10
    end
  end

  test "submitting the bulk-priority form updates the todos and morphs the table" do
    visit suite_turbo_todos_table_path

    # Confirm initial priorities are "low" for the first two todos.
    assert_equal "low", @todo1.reload.priority
    assert_equal "low", @todo2.reload.priority

    # Select the first two rows.
    checkboxes = all("input[type='checkbox'][name^='todo_ids_']")
    checkboxes[0].click
    checkboxes[1].click

    sleep 0.5

    # BulkActionsBar becomes visible.
    assert_selector BULK_BAR_SELECTOR, visible: true, wait: 5

    # Click "Set Priority".
    within BULK_BAR_SELECTOR do
      find("button[data-modal='true']", text: /Set Priority/i).click
    end

    # Wait for modal to open and form to load.
    assert_selector "#{BULK_MODAL_SELECTOR}[open]", wait: 10
    within "#{BULK_MODAL_SELECTOR}[open]" do
      assert_selector "select#bulk_priority_select", wait: 10

      # Choose "high" priority.
      find("select#bulk_priority_select").find("option[value='high']").select_option

      # Submit the form.
      find("#bulk_priority_submit").click
    end

    # After redirect (303 → GET), stay on the table page.
    assert_current_path suite_turbo_todos_table_path, wait: 10

    # The two selected todos should now have priority "high".
    assert_equal "high", @todo1.reload.priority
    assert_equal "high", @todo2.reload.priority

    # The third todo (not selected) should be unchanged.
    assert_equal "medium", @todo3.reload.priority

    # The table should reflect the updated priorities.
    assert_selector "table", text: "High", wait: 5
  end
end
