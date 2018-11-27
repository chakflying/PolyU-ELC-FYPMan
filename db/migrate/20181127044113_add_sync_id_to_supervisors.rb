class AddSyncIdToSupervisors < ActiveRecord::Migration[5.2]
  def change
    add_column :supervisors, :sync_id, :integer
  end
end
