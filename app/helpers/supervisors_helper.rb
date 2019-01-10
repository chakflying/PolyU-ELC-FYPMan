module SupervisorsHelper
    include OldDbHelper

    def olddb_supervisor_create(params)
        @old_supervisor = OldUsers.create(common_name: params[:name], net_id: params[:netID], department: check_old_department(params[:department]), status: 1, role: 2, uuid: 0, program_code: 0, subject_code: 0, senior_year: 0)
        return @old_supervisor.id
    end

    def olddb_supervisor_update(params)
        @old_supervisor = OldUsers.first(net_id: params[:netID])
        @old_supervisor.update(common_name: params[:name], net_id: params[:netID], department: check_old_department(params[:department]))
    end

    def olddb_supervisor_destroy(sync_id)
        @old_supervisor = OldUsers[sync_id]
        @old_supervisor.destroy
    end

    def olddb_supervisor_removeStudent(stu_netID, sup_netID)
        @old_student = OldUsers.first(net_id: stu_netID)
        @old_supervisor = OldUsers.first(net_id: sup_netID)
        @old_rel = OldRelations.first(student_net_id: @old_student.id, supervisor_net_id: @old_supervisor.id)
        @old_rel.destroy
    end
end
