module StudentsHelper
    include OldDbHelper

    def get_fyp_years_list
        return [
          [Time.now.year.to_s + '-' + (Time.now.year + 1).to_s, Time.now.year.to_s + '-' + (Time.now.year + 1).to_s],
          [(Time.now.year + 1).to_s + '-' + (Time.now.year + 2).to_s, (Time.now.year + 1).to_s + '-' + (Time.now.year + 2).to_s],
          [(Time.now.year + 2).to_s + '-' + (Time.now.year + 3).to_s, (Time.now.year + 2).to_s + '-' + (Time.now.year + 3).to_s],
          [(Time.now.year + 3).to_s + '-' + (Time.now.year + 4).to_s, (Time.now.year + 3).to_s + '-' + (Time.now.year + 4).to_s],
          [(Time.now.year + 4).to_s + '-' + (Time.now.year + 5).to_s, (Time.now.year + 4).to_s + '-' + (Time.now.year + 5).to_s],
          [(Time.now.year + 5).to_s + '-' + (Time.now.year + 6).to_s, (Time.now.year + 5).to_s + '-' + (Time.now.year + 6).to_s],
        ]
    end

    def olddb_student_create(params)
        @old_student = OldUsers.create(common_name: params[:name], net_id: params[:netID], FYPyear: params[:fyp_year], department: check_old_department(Department.find(params[:department_id]).name), status: 1, role: 1, uuid: 0, program_code: 0, subject_code: 0, senior_year: 0)
        return @old_student.id
    end

    def olddb_student_update(params)
        @old_student = OldUsers.first(net_id: params[:netID])
        @old_student.update(common_name: params[:name], net_id: params[:netID], FYPyear: params[:fyp_year], department: check_old_department(Department.find(params[:department_id]).name))
    end

    def olddb_student_destroy(sync_id)
        @old_student = OldUsers[sync_id]
        @old_student.destroy
    end

    def olddb_student_removeSupervisor(stu_netID, sup_netID)
        @old_student = OldUsers.first(net_id: stu_netID)
        @old_supervisor = OldUsers.first(net_id: sup_netID)
        @old_rel = OldRelations.first(student_net_id: @old_student.id, supervisor_net_id: @old_supervisor.id)
        @old_rel.destroy
    end
end
