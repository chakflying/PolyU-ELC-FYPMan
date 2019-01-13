class CreateFaculties < ActiveRecord::Migration[5.2]
  def change
    create_table :faculties do |t|
      t.string :name, null: false
      t.string :code, :limit => 8
      t.integer :sync_id

      t.timestamps
    end
    add_reference :departments, :faculty
  end
end
