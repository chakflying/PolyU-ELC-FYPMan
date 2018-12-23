class AddColorToTodos < ActiveRecord::Migration[5.2]
  def change
    add_column :todos, :color, :string, :limit => 10, :default => "danger"
  end
end
