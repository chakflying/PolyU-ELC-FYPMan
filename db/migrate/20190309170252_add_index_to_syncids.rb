class AddIndexToSyncids < ActiveRecord::Migration[5.2]
  def change
    add_index :students, :sync_id
    add_index :supervisors, :sync_id
    add_index :todos, :sync_id
    add_index :departments, :sync_id
    add_index :faculties, :sync_id
    add_index :universities, :sync_id
  end
end
