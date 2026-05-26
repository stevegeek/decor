require "test_helper"

class SuiteTodosTest < ActionDispatch::IntegrationTest
  test "index renders a suite form opted out of Turbo and wired for UJS" do
    get suite_todos_path
    assert_response :success
    assert_match(/data-turbo="false"/, response.body)   # opted out of Turbo
    assert_match(/data-remote="true"/, response.body)    # UJS remote form
    assert_match(/data-type="json"/, response.body)       # suite form sets json type
    assert_select "input[name='todo[title]']"
  end

  test "valid create returns 201 JSON with the rendered row html" do
    assert_difference -> { Todo.count }, 1 do
      post suite_todos_path,
        params: {todo: {title: "Ship the gem", priority: "high"}},
        as: :json
    end
    assert_response :created
    body = JSON.parse(response.body)
    assert body["id"].present?
    assert_match(/Ship the gem/, body["html"])
  end

  test "invalid create returns 422 JSON with error messages" do
    assert_no_difference -> { Todo.count } do
      post suite_todos_path,
        params: {todo: {title: "", priority: "low"}},
        as: :json
    end
    assert_response :unprocessable_entity
    body = JSON.parse(response.body)
    assert_includes body["errors"], "Title can't be blank"
  end
end
