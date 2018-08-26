class CreateJoinTableStudentsSupervisors < ActiveRecord::Migration[5.2]
  def change
    create_join_table :students, :supervisors do |t|
      # t.index [:student_id, :supervisor_id]
      # t.index [:supervisor_id, :student_id]
    end
  end
end
