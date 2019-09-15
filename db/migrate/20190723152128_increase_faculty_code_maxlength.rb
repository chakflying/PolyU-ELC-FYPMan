class IncreaseFacultyCodeMaxlength < ActiveRecord::Migration[5.2]
  def change
    change_column :faculties, :code, :string, :limit => 255
    change_column :universities, :code, :string, :limit => 255
  end
end
