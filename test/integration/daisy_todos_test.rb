require "test_helper"

class DaisyTodosTest < ActionDispatch::IntegrationTest
  test "index renders a daisy form wired for Turbo Drive" do
    get daisy_todos_path
    assert_response :success
    # turbo: true => the form participates in Turbo Drive (NOT opted out).
    assert_match(/data-turbo="true"/, response.body)
    assert_select "input[name='todo[title]']"
    assert_select "form[action='#{daisy_todos_path}']"
  end

  test "valid create responds 303 See Other and redirects to index" do
    assert_difference -> { Todo.count }, 1 do
      post daisy_todos_path, params: {todo: {title: "Write the report", priority: "high"}}
    end
    assert_response :see_other
    assert_redirected_to daisy_todos_path
  end

  test "invalid create re-renders index with 422 and shows errors" do
    assert_no_difference -> { Todo.count } do
      post daisy_todos_path, params: {todo: {title: "", priority: "low"}}
    end
    assert_response :unprocessable_entity
    assert_select "#daisy-errors"
    assert_match(/can't be blank/, response.body)
  end
end
