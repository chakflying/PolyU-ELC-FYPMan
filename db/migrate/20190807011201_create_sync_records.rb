class CreateSyncRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :sync_records do |t|
      t.datetime :started_at
      t.datetime :ended_at
      t.integer :errors
      t.text :errors_text

      t.timestamps
    end
  end
end
