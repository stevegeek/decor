require "test_helper"

class TodoTest < ActiveSupport::TestCase
  test "valid with title >= 3 chars and a valid priority" do
    todo = Todo.new(title: "Buy milk", priority: "low")
    assert todo.valid?, todo.errors.full_messages.to_sentence
  end

  test "invalid without a title" do
    todo = Todo.new(title: "", priority: "low")
    assert_not todo.valid?
    assert_includes todo.errors[:title], "can't be blank"
  end

  test "invalid when title shorter than 3 chars" do
    todo = Todo.new(title: "ab", priority: "low")
    assert_not todo.valid?
    assert_includes todo.errors[:title], "is too short (minimum is 3 characters)"
  end

  test "invalid with an unknown priority" do
    todo = Todo.new(title: "Walk dog", priority: "urgent")
    assert_not todo.valid?
  end

  test "title must be unique" do
    Todo.create!(title: "Existing task", priority: "low")
    dup = Todo.new(title: "Existing task", priority: "high")
    assert_not dup.valid?
    assert_includes dup.errors[:title], "has already been taken"
  end
end
