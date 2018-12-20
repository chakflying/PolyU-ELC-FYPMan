class OldDb < ActiveRecord::Base
    def self.check_department(name)
        if name == ""
            return nil
        end
        if dep = Department.find_by(name: name)
            return dep.id
        else
            dep = Department.create(name: name, code: "UNKNOWN")
            return dep.id
        end
    end

    # Simple old database sync
    def self.sync
        OldUsers.each do |entry|
            next if entry.status == 0
            if entry.FYPyear == nil or entry.FYPyear == ""
                @fyp_year = Time.now.year.to_s + '-' + (Time.now.year + 1).to_s
            else
                @fyp_year = entry.FYPyear
            end
            if entry.department != nil
                @department = OldDepartments[entry.department].name
            else
                @department = ""
            end
            if entry.role == "1"
                # is a student
                if(!Student.find_by(netID: entry.net_id))
                    @student = Student.new(netID: entry.net_id, name: entry.common_name, department_id: check_department(@department), fyp_year: @fyp_year, sync_id: entry.id)
                    @student.save!
                end
            elsif entry.role == "2"
                # is a supervisor
                if(!Supervisor.find_by(netID: entry.net_id))
                    @supervisor = Supervisor.new(netID: entry.net_id, name: entry.common_name, department_id: check_department(@department), sync_id: entry.id)
                    @supervisor.save!
                end
            end
        end
        Student.where.not(sync_id: nil) do |student|
            stu = OldUsers[student.sync_id]
            if (stu == nil)
                student.delete
            else
                student.department_id = ( stu.department ? check_department(OldDepartments[stu.department].name) : nil )
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
                supervisor.department_id = ( sup.department ? check_department(OldDepartments[sup.department].name) : nil )
                supervisor.name = sup.common_name
                supervisor.netID = sup.net_id
                supervisor.save!
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
            department_id = ( old_todo.issued_department ? check_department(OldDepartments[old_todo.issued_department].name) : nil )
 
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