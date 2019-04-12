class MoveToThroughAssociation < ActiveRecord::Migration[5.2]
  def change
    drop_join_table :students, :supervisors

    create_table :supervisions do |t|
      t.belongs_to :student, index: true
      t.belongs_to :supervisor, index: true
      t.timestamps
    end
  end
end
