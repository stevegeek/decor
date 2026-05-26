# frozen_string_literal: true

class Suite::Turbo::TodosTablesController < ApplicationController
  layout "todos"

  # GET /suite/turbo/todos_table — table page.
  def show
    # DataTableBuilder pulls Todo.order(:id) from its own query method.
  end

  # GET /suite/turbo/todos_table/bulk_priority
  # Renders the priority-select form fragment loaded into the modal body.
  def bulk_priority
    @selected_ids = Array(params[:selected_ids]).map(&:to_i).select(&:positive?)
    render layout: false
  end

  # POST /suite/turbo/todos_table/bulk_priority_submit
  # Updates the selected todos' priority and redirects back (Turbo morph).
  def bulk_priority_submit
    ids      = Array(params[:todo_ids]).map(&:to_i).select(&:positive?)
    priority = params[:priority].to_s
    if Todo::PRIORITIES.include?(priority) && ids.any?
      Todo.where(id: ids).update_all(priority: priority)
    end
    redirect_to suite_turbo_todos_table_path, status: :see_other
  end
end
