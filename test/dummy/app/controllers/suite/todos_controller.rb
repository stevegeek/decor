class Suite::TodosController < ApplicationController
  layout "todos"

  def index
    @todos = Todo.order(:id)
    @todo = Todo.new
  end

  def create
    @todo = Todo.new(todo_params)
    if @todo.save
      render json: {
        id: @todo.id,
        html: render_to_string(partial: "todos/todo", locals: {todo: @todo}, formats: [:html])
      }, status: :created
    else
      render json: {errors: @todo.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def todo_params
    params.require(:todo).permit(:title, :description, :priority, :completed, :due_on)
  end
end
