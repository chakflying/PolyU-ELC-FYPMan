class CreateDepartments < ActiveRecord::Migration[5.2]
  def change
    remove_column :students, :department
    remove_column :supervisors, :department
    create_table :departments do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
    add_reference :students, :department
    add_reference :supervisors, :department
  end
end
