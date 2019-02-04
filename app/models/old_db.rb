# frozen_string_literal: true

class OldDb < ActiveRecord::Base
  def self.department_check(dep_name)
    return nil if (dep_name == '') || dep_name.nil?

    @dep = OldDepartment.first(name: dep_name)
    @dep ||= OldDepartment.create(name: dep_name, status: 1)
    @dep.id
  end

  # Simple old database sync
  def self.sync
    # Update Universities according to old DB
    OldUniversity.each do |old_uni|
      next if old_uni.status != 1

      if (cur = University.find_by(sync_id: old_uni.id))
        cur.name = old_uni.name
        cur.code = old_uni.short_name
        cur.save
      else
        University.create(name: old_uni.name, code: old_uni.short_name, sync_id: old_uni.id)
      end
    end
    University.where.not(sync_id: nil) do |uni|
      @university = OldDepartment[uni.sync_id]
      uni.delete if @university.nil?
    end

    # Update Faculties according to old DB
    OldFaculty.each do |old_fac|
      next if old_fac.status != 1

      u_id = University.find_by(sync_id: old_fac.university).id unless University.find_by(sync_id: old_fac.university).nil?
      if (cur = Faculty.find_by(sync_id: old_fac.id))
        cur.name = old_fac.name
        cur.code = old_fac.short_name
        cur.university_id = u_id
        cur.save
      else
        Faculty.create(name: old_fac.name, code: old_fac.short_name, university_id: (!u_id.blank? ? u_id : nil), sync_id: old_fac.id)
      end
    end
    Faculty.where.not(sync_id: nil) do |fac|
      @faculty = OldDepartment[fac.sync_id]
      fac.delete if @faculty.nil?
    end

    # Update Departments according to old DB
    OldDepartment.each do |old_dep|
      next if old_dep.status != 1

      f_id = Faculty.find_by(sync_id: old_dep.faculty).id unless Faculty.find_by(sync_id: old_dep.faculty).nil?
      if (cur = Department.find_by(sync_id: old_dep.id))
        cur.name = old_dep.name
        cur.code = old_dep.short_name
        cur.faculty_id = f_id
        cur.save
      else
        Department.create(name: old_dep.name, code: old_dep.short_name, faculty_id: (!f_id.blank? ? f_id : nil), sync_id: old_dep.id)
      end
    end
    Department.where.not(sync_id: nil) do |dep|
      @department = OldDepartment[dep.sync_id]
      dep.delete if @department.nil?
    end

    # Update Students according to old DB
    Student.where.not(sync_id: nil) do |student|
      stu = OldUser[student.sync_id]
      if stu.nil?
        student.delete
      else
        student.department_id = Department.check_synced(stu.department)
        student.name = stu.common_name
        student.fyp_year = (stu.FYPyear == '' ? Time.now.year.to_s + '-' + (Time.now.year + 1).to_s : stu.FYPyear)
        student.netID = stu.net_id
        student.save!
      end
    end

    # Update Supervisors according to old DB
    Supervisor.where.not(sync_id: nil) do |supervisor|
      sup = OldUser[supervisor.sync_id]
      if sup.nil?
        supervisor.delete
      else
        supervisor.department_id = Department.check_synced(sup.department)
        supervisor.name = sup.common_name
        supervisor.netID = sup.net_id
        supervisor.save!
      end
    end

    # Create new Students/Supervisors according to old DB
    OldUser.each do |entry|
      next if (entry.status != 1) || entry.department.nil?

      @fyp_year = if entry.FYPyear.nil? || (entry.FYPyear == '')
                    Time.now.year.to_s + '-' + (Time.now.year + 1).to_s
                  else
                    entry.FYPyear
                  end
      d_id = Department.check_synced(entry.department)
      next unless d_id

      if entry.role == '1'
        # is a student
        if stu = Student.find_by(netID: entry.net_id)
          entry.department = Department.find(stu.department_id).sync_id
          entry.save
        else
          @student = Student.new(netID: entry.net_id, name: entry.common_name, department_id: d_id, fyp_year: @fyp_year, sync_id: entry.id)
          @student.save!
        end
      elsif entry.role == '2'
        # is a supervisor
        if sup = Supervisor.find_by(netID: entry.net_id)
          entry.department = Department.find(sup.department_id).sync_id
          entry.save
        else
          @supervisor = Supervisor.new(netID: entry.net_id, name: entry.common_name, department_id: d_id, sync_id: entry.id)
          @supervisor.save!
        end
      end
    end

    # Update Relations according to old DB
    OldRelation.each do |rel|
      next if rel.status != 1

      if OldUser[rel.student_net_id.to_i]
        @stu = Student.find_by(sync_id: rel.student_net_id.to_i)
      end
      if OldUser[rel.supervisor_net_id.to_i]
        @sup = Supervisor.find_by(sync_id: rel.supervisor_net_id.to_i)
      end
      if @stu && @sup && !@stu.supervisors.find_by(id: @sup.id)
        @stu.supervisors << @sup
      end
      # Delete if relation is invalid
      if !OldUser[rel.student_net_id.to_i] || !OldUser[rel.supervisor_net_id.to_i]
        rel.delete
      end
    end

    # Update Todos according to old DB
    OldTodo.each do |old_todo|
      next if old_todo.status != 1

      @todo = Todo.find_by(sync_id: old_todo.id)
      department_id = Department.check_synced(old_todo.issued_department)

      if !@todo.nil?
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
      @todo = OldTodo[todo_item.sync_id]
      todo_item.delete if @todo.nil?
    end
  end
end
