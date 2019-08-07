class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :sync_records, :errors, :num_errors
  end
end
