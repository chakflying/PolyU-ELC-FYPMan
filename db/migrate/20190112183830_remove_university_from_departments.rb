class RemoveUniversityFromDepartments < ActiveRecord::Migration[5.2]
  def change
    remove_reference :departments, :university
  end
end
