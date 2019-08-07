class CreateGroupsSupervisors < ActiveRecord::Migration[5.2]
  def change
    create_table :groups_supervisors do |t|
      t.references :group, foreign_key: true
      t.references :supervisor, foreign_key: true

      t.timestamps
    end
  end
end
