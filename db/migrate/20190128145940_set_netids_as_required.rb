class SetNetidsAsRequired < ActiveRecord::Migration[5.2]
  def change
    change_column_null(:students, :netID, false)
    change_column_null(:supervisors, :netID, false)
  end
end
