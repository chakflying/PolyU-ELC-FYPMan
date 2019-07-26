class CreateGroupsStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :groups_students do |t|
      t.references :group, foreign_key: true
      t.references :student, foreign_key: true

      t.timestamps
    end
  end
end
