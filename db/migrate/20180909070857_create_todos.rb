class CreateTodos < ActiveRecord::Migration[5.2]
  def change
    create_table :todos do |t|
      t.string :department
      t.string :title
      t.text :description
      t.datetime :eta
    end
  end
end
