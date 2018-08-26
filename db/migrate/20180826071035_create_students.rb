class CreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :students do |t|
      t.string :name
      t.string :netID
      t.string :department

      t.timestamps
    end

    create_table :supervisors do |t|
      t.string :name
      t.string :netID
      t.string :department

      t.timestamps
    end
  end
end
