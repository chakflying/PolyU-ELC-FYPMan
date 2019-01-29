class SetTodosTitleAsRequired < ActiveRecord::Migration[5.2]
  def change
    change_column_null(:todos, :title, false)
  end
end
