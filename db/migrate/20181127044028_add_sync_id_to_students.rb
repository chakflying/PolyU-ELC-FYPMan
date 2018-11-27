class AddSyncIdToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :sync_id, :integer
  end
end
