class AddTimestampsToTodos < ActiveRecord::Migration[5.2]
  def change
    add_timestamps :todos, default: DateTime.now
    change_column_default :todos, :created_at, from: DateTime.now, to: nil
    change_column_default :todos, :updated_at, from: DateTime.now, to: nil
  end
end
