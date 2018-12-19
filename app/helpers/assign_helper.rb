module AssignHelper
    def olddb_assign(stu_netID, sup_netID)
        @old_student = OldUsers.first(net_id: stu_netID)
        @old_supervisor = OldUsers.first(net_id: sup_netID)
        @old_rel = OldRelations.create(student_net_id: @old_student.id, supervisor_net_id: @old_supervisor.id, status: 1)
    end
end
