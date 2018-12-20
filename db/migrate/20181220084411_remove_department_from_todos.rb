class RemoveDepartmentFromTodos < ActiveRecord::Migration[5.2]
  def change
    remove_column :todos, :department
    remove_column :users, :department
    add_reference :todos, :department
    add_reference :users, :department
  end
end
