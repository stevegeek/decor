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

  # GET /suite/turbo/todos/bulk_priority
  # Renders the priority-select form fragment loaded into the modal body.
  def bulk_priority
    @selected_ids = Array(params[:selected_ids]).map(&:to_i).select(&:positive?)
    render layout: false
  end

  # POST /suite/turbo/todos/bulk_priority_submit
  # Updates the selected todos' priority and redirects back (Turbo morph).
  def bulk_priority_submit
    ids      = Array(params[:todo_ids]).map(&:to_i).select(&:positive?)
    priority = params[:priority].to_s
    if Todo::PRIORITIES.include?(priority) && ids.any?
      Todo.where(id: ids).update_all(priority: priority)
    end
    redirect_to suite_turbo_todos_path, status: :see_other
  end

  private

  def todo_params
    params.require(:todo).permit(:title, :description, :priority, :completed, :due_on)
  end
end
