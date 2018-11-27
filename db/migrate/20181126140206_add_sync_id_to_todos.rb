class AddSyncIdToTodos < ActiveRecord::Migration[5.2]
  def change
    add_column :todos, :sync_id, :integer
  end
end
