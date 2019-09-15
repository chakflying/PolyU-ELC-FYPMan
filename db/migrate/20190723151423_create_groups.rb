class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.integer :type, null: false
      t.integer :sync_id
      t.integer :number

      t.timestamps
    end
    add_index :groups, :sync_id
  end
end
