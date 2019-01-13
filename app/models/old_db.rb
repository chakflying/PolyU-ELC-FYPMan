class OldDb < ActiveRecord::Base
    def self.department_check(dep_name)
        if dep_name == "" or dep_name == nil
            return nil
        end
        @dep = OldDepartments.first(name: dep_name)
        if !@dep
            @dep = OldDepartments.create(name: dep_name, status: 1)
        end
        return @dep.id
    end

    # Simple old database sync
    def self.sync
        OldUniversities.each do |old_uni|
            next if old_uni.status == 0
            if (cur = University.find_by(sync_id: old_uni.id))
                cur.name = old_uni.name
                cur.code = old_uni.short_name
                cur.save
            else
                University.create(name: old_uni.name, code: old_uni.short_name, sync_id: old_uni.id)
            end
        end

        OldFaculties.each do |old_fac|
            next if old_fac.status == 0
            u_id = University.find_by(sync_id: old_fac.university).id unless University.find_by(sync_id: old_fac.university).nil?
            if (cur = Faculty.find_by(sync_id: old_fac.id))
                cur.name = old_fac.name
                cur.code = old_fac.short_name
                cur.university_id = u_id
                cur.save
            else
                Faculty.create(name: old_fac.name, code: old_fac.short_name, university_id: u_id, sync_id: old_fac.id)
            end
        end

        OldDepartments.each do |old_dep|
            next if old_dep.status == 0
            f_id = Faculty.find_by(sync_id: old_dep.faculty).id unless Faculty.find_by(sync_id: old_dep.faculty).nil?
            if (cur = Department.find_by(sync_id: old_dep.id))
                cur.name = old_dep.name
                cur.code = old_dep.short_name
                cur.faculty_id = f_id
                cur.save
            else
                Department.create(name: old_dep.name, code: old_dep.short_name, faculty_id: f_id, sync_id: old_dep.id)
            end
        end

        Student.where.not(sync_id: nil) do |student|
            stu = OldUsers[student.sync_id]
            if (stu == nil)
                student.delete
            else
                student.department_id = Department.check_synced(stu.department)
                student.name = stu.common_name
                student.fyp_year = ( ( stu.FYPyear == "" ) ? Time.now.year.to_s + '-' + (Time.now.year + 1).to_s : stu.FYPyear)
                student.netID = stu.net_id
                student.save!
            end
        end
        Supervisor.where.not(sync_id: nil) do |supervisor|
            sup = OldUsers[supervisor.sync_id]
            if (sup == nil)
                supervisor.delete
            else
                supervisor.department_id = Department.check_synced(sup.department)
                supervisor.name = sup.common_name
                supervisor.netID = sup.net_id
                supervisor.save!
            end
        end
        OldUsers.each do |entry|
            next if entry.status == 0 or entry.department.nil?
            if entry.FYPyear == nil or entry.FYPyear == ""
                @fyp_year = Time.now.year.to_s + '-' + (Time.now.year + 1).to_s
            else
                @fyp_year = entry.FYPyear
            end
            d_id = Department.check_synced(entry.department)
            next if !d_id
            if entry.role == "1"
                # is a student
                if(!Student.find_by(netID: entry.net_id))
                    @student = Student.new(netID: entry.net_id, name: entry.common_name, department_id: d_id, fyp_year: @fyp_year, sync_id: entry.id)
                    @student.save!
                end
            elsif entry.role == "2"
                # is a supervisor
                if(!Supervisor.find_by(netID: entry.net_id))
                    @supervisor = Supervisor.new(netID: entry.net_id, name: entry.common_name, department_id: d_id, sync_id: entry.id)
                    @supervisor.save!
                end
            end
        end
        OldRelations.each do |rel|
            next if rel.status == 0
            if (OldUsers[rel.student_net_id.to_i])
                @stu = Student.find_by(netID: OldUsers[rel.student_net_id.to_i].net_id)
            end
            if (OldUsers[rel.supervisor_net_id.to_i])
                @sup = Supervisor.find_by(netID: OldUsers[rel.supervisor_net_id.to_i].net_id)
            end
            if (@stu && @sup && !@stu.supervisors.find_by(id: @sup.id))
                @stu.supervisors << @sup
            end
        end
        OldTodos.each do |old_todo|
            next if old_todo.status == 0
            @todo = Todo.find_by(sync_id: old_todo.id)
            department_id = Department.check_synced(old_todo.issued_department)
 
            if @todo != nil
                @todo.title = old_todo.title
                @todo.description = old_todo.description
                @todo.department_id = department_id
                @todo.eta = old_todo.time
                @todo.save
            else
                @todo = Todo.new(title: old_todo.title, description: old_todo.description, department_id: department_id, eta: old_todo.time, sync_id: old_todo.id)
                @todo.save
            end
        end
        Todo.where.not(sync_id: nil) do |todo_item|
            @todo = OldTodos[todo_item.sync_id]
            if @todo == nil
                todo_item.delete
            end
        end
    end
end