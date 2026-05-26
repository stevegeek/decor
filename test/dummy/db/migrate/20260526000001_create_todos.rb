class CreateTodos < ActiveRecord::Migration[8.1]
  def change
    create_table :todos do |t|
      t.string :title, null: false
      t.text :description
      t.string :priority, default: "low", null: false
      t.boolean :completed, default: false, null: false
      t.date :due_on
      t.timestamps
    end
  end
end
