# frozen_string_literal: true

class TodosTableBuilder < Decor::Suite::Tables::DataTableBuilder
  def query
    Todo.order(:id)
  end

  def pagination_options
    {path: helpers.suite_turbo_todos_path}
  end

  # Todo has no encoded_id, so send integer ids in selected_ids[]:
  def selectable_value_for_row(row_data, _transformed, _index, _item_index)
    row_data.id.to_s
  end

  def setup_data_table
    column(:title, title: "Task", stretch: true) { |t| t.title }
    column(:priority) { |t| t.priority.capitalize }
    column(:completed, title: "Done") { |t| t.completed? ? "Yes" : "No" }
    bulk_action(
      :set_priority,
      label: "Set Priority",
      icon: "pencil",
      style: :primary,
      url: helpers.bulk_priority_suite_turbo_todos_path,
      http_method: :get,
      modal: true,
      inline: true
    )
  end
end
