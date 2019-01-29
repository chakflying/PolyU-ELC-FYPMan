# frozen_string_literal: true

class SetDepartmentsFacultiesNameAsRequired < ActiveRecord::Migration[5.2]
  def change
    change_column_null(:departments, :name, false)
    change_column_null(:faculties, :name, false)
  end
end
