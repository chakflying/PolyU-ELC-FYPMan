class AddDefaultToGroupsType < ActiveRecord::Migration[5.2]
  def change
    change_column_default :groups, :type, 0
  end
end
