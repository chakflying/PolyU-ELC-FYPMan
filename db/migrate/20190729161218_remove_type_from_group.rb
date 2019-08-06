class RemoveTypeFromGroup < ActiveRecord::Migration[5.2]
  def change
    remove_column :groups, :type, :integer
  end
end
