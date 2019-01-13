class AddSyncIdToDepartments < ActiveRecord::Migration[5.2]
  def change
    add_column :departments, :sync_id, :integer
  end
end
