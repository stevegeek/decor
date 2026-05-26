class Suite::Turbo::TodosController < ApplicationController
  layout "todos"

  def index
    @todos = Todo.order(:id)
    @todo = Todo.new
  end

  def create
    @todo = Todo.new(todo_params)
    if @todo.save
      redirect_to suite_turbo_todos_path, status: :see_other
    else
      @todos = Todo.order(:id)
      render :index, status: :unprocessable_entity
    end
  end

  private

  def todo_params
    params.require(:todo).permit(:title, :description, :priority, :completed, :due_on)
  end
end
