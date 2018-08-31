class AddFypYearToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :fyp_year, :string
  end
end
