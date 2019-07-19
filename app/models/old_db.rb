# frozen_string_literal: true

class OldDb < ActiveRecord::Base
  def self.department_check(dep_name)
    return nil if dep_name.blank?

    @dep = OldDepartment.first(name: dep_name)
    @dep ||= OldDepartment.create(name: dep_name, status: 1)
    @dep.id
  end

  # Simple old database sync
  def self.sync
    errors = 0
    errors_text = []
    puts('') unless Rails.env.test?
    puts('---------------------------------------------') unless Rails.env.test?
    ActiveRecord::Base.connection.cache do
      # Update Universities according to old DB
      puts('Updating Universities...') unless Rails.env.test?
      University.where.not(sync_id: nil).where.not(sync_id: OldUniversity.where(status: 1).pluck(:id)).each(&:destroy)

      synced_universities = University.where(sync_id: OldUniversity.where(status: 1).pluck(:id))
      OldUniversity.each do |old_uni|
        next if old_uni.status != 1

        if old_uni.date_modified.blank?
          old_uni.date_modified = old_uni.date_created || 1.year.ago
          old_uni.save
        end

        # Previously Synced
        uni = synced_universities.select { |x| x.sync_id == old_uni.id }.first
        if uni.present?
          uni.name = old_uni.name
          uni.code = old_uni.short_name
          next if uni.changed.blank?

          unless uni.save
            errors_text.append('[OldDB University] Sync failed on: ' + old_uni.values.to_s)
            errors_text.append(uni.errors.full_messages)
            errors += 1
          end
        else
          new_uni = University.new(name: old_uni.name, code: old_uni.short_name, sync_id: old_uni.id)
          unless new_uni.save
            errors_text.append('[New University] Sync failed on: ' + old_uni.values.to_s)
            errors_text.append(new_uni.errors.full_messages)
            errors += 1
          end
        end
      end

      University.where(sync_id: nil).each do |uni|
        old_uni = OldUniversity.new(name: uni.name, short_name: uni.code, status: 1)
        if !old_uni.save
          errors_text.append('[New OldDB University] Sync failed on: ' + old_uni.values.to_s)
          errors_text.append(old_uni.errors.full_messages)
          errors += 1
        else
          uni.sync_id = old_uni.id
          unless uni.save
            errors_text.append('[New OldDB University] SyncID update failed on: ' + old_uni.values.to_s)
            errors_text.append(uni.errors.full_messages)
            errors += 1
          end
        end
      end

      # Update Faculties according to old DB
      puts('Updating Faculties...') unless Rails.env.test?
      Faculty.where.not(sync_id: nil).where.not(sync_id: OldFaculty.where(status: 1).pluck(:id)).each(&:destroy)

      synced_faculties = Faculty.where(sync_id: OldFaculty.where(status: 1).pluck(:id))
      OldFaculty.each do |old_fac|
        next if old_fac.status != 1 || old_fac.university.blank?

        if old_fac.date_modified.blank?
          old_fac.date_modified = old_fac.date_created || 1.year.ago
          old_fac.save
        end

        u_id = University.find_by(sync_id: old_fac.university).id unless University.find_by(sync_id: old_fac.university).blank?

        # Previously Synced
        fac = synced_faculties.select { |x| x.sync_id == old_fac.id }.first
        if fac.present?
          fac.name = old_fac.name
          fac.code = old_fac.short_name
          fac.university_id = u_id
          next if fac.changed.blank?

          unless fac.save
            errors_text.append('[OldDB Faculty] Sync failed on: ' + old_fac.values.to_s)
            errors_text.append(fac.errors.full_messages)
            errors += 1
          end
        else
          new_fac = Faculty.new(name: old_fac.name, code: old_fac.short_name, university_id: (!u_id.blank? ? u_id : nil), sync_id: old_fac.id)
          unless new_fac.save
            errors_text.append('[New Faculty] Sync failed on: ' + old_fac.values.to_s)
            errors_text.append(new_fac.errors.full_messages)
            errors += 1
          end
        end
      end

      Faculty.where(sync_id: nil).each do |fac|
        old_fac = OldFaculty.new(name: fac.name, short_name: fac.code, university: (fac.university.present? ? fac.university.sync_id : nil), status: 1)
        if !old_fac.save
          errors_text.append('[New OldDB Faculty] Sync failed on: ' + old_fac.values.to_s)
          errors_text.append(old_fac.errors.full_messages)
          errors += 1
        else
          fac.sync_id = old_fac.id
          unless fac.save
            errors_text.append('[New OldDB Faculty] SyncID update failed on: ' + old_fac.values.to_s)
            errors_text.append(fac.errors.full_messages)
            errors += 1
          end
        end
      end

      # Update Departments according to old DB
      puts('Updating Departments...') unless Rails.env.test?
      Department.where.not(sync_id: nil).where.not(sync_id: OldDepartment.where(status: 1).pluck(:id)).each(&:destroy)

      synced_departments = Department.where(sync_id: OldDepartment.where(status: 1).pluck(:id))
      OldDepartment.each do |old_dep|
        next if old_dep.status != 1 || old_dep.name.blank?

        if old_dep.date_modified.blank?
          old_dep.date_modified = old_dep.date_created || 1.year.ago
          old_dep.save
        end

        f_id = Faculty.find_by(sync_id: old_dep.faculty).id unless Faculty.find_by(sync_id: old_dep.faculty).blank?

        # Previously Synced
        dep = synced_departments.select { |x| x.sync_id == old_dep.id }.first
        if dep.present?
          next if (dep.updated_at - old_dep.date_modified).abs < 1

          if dep.updated_at < old_dep.date_modified
            # The OldDb one is newer
            # puts("case 1") if Rails.env.development? || Rails.env.test?
            dep.name = old_dep.name
            dep.code = old_dep.short_name
            dep.faculty_id = f_id

            if dep.changed.blank?
              dep.touch && old_dep.touch
            else
              unless dep.save && old_dep.touch
                errors_text.append('[Department] Sync failed on: ' + dep.attributes.to_s)
                errors_text.append(dep.errors.full_messages)
                errors += 1
              end
            end
          else
            # This one is newer than the OldDb one
            # puts("case 2") if Rails.env.development? || Rails.env.test?
            old_dep.name = dep.name
            old_dep.short_name = dep.code
            old_dep.faculty = (dep.faculty.present? ? dep.faculty.sync_id : nil)

            unless old_dep.save && dep.touch
              errors_text.append('[OldDB Department] Sync failed on: ' + old_dep.values.to_s)
              errors_text.append(old_dep.errors.full_messages)
              errors += 1
            end
          end
        else
          # puts("case 3") if Rails.env.development? || Rails.env.test?
          new_dep = Department.new(name: old_dep.name, code: old_dep.short_name, faculty_id: (!f_id.blank? ? f_id : nil), sync_id: old_dep.id)
          unless new_dep.save
            errors_text.append('[New Department] Sync failed on: ' + old_dep.values.to_s)
            errors_text.append(new_dep.errors.full_messages)
            errors += 1
          end
        end
      end

      Department.where(sync_id: nil).each do |dep|
        old_dep = OldDepartment.new(name: dep.name, short_name: dep.code, faculty: (dep.faculty.present? ? dep.faculty.sync_id : nil), status: 1)
        if !old_dep.save
          errors_text.append('[New OldDB Department] Sync failed on: ' + old_dep.values.to_s)
          errors_text.append(old_dep.errors.full_messages)
          errors += 1
        else
          dep.sync_id = old_dep.id
          unless dep.save
            errors_text.append('[New OldDB Department] SyncID update failed on: ' + old_dep.values.to_s)
            errors_text.append(dep.errors.full_messages)
            errors += 1
          end
        end
      end

      # Remove Students according to old DB
      puts('Removing deleted students...') unless Rails.env.test?
      Student.where.not(sync_id: nil).where.not(sync_id: OldUser.where(status: 1, role: 1).pluck(:id)).each(&:destroy)

      # Remove Supervisors according to old DB
      puts('Removing deleted supervisors...') unless Rails.env.test?
      Supervisor.where.not(sync_id: nil).where.not(sync_id: OldUser.where(status: 1, role: 2).pluck(:id)).each(&:destroy)

      # Create/Update Students/Supervisors according to old DB
      synced_students = Student.where(sync_id: OldUser.where(status: 1, role: 1).pluck(:id))
      synced_supervisors = Supervisor.where(sync_id: OldUser.where(status: 1, role: 2).pluck(:id))
      puts('Updating Supervisors/Students...') unless Rails.env.test?
      OldUser.each do |entry|
        next if (entry.status != 1) || entry.department.blank?

        if entry.date_modified.blank?
          entry.date_modified = entry.date_created
          entry.save
        end

        @fyp_year = if entry.FYPyear.blank?
                      Time.now.year.to_s + '-' + (Time.now.year + 1).to_s
                    else
                      entry.FYPyear
                    end

        dep = synced_departments.select { |x| x.sync_id == entry.department }.first
        next unless dep

        d_id = dep.id

        if entry.role == '1'
          # is a student
          stu = synced_students.select { |x| x.netID == entry.net_id }.first
          if stu.present?
            if stu.sync_id == entry.id
              next if (stu.updated_at - entry.date_modified).abs < 1

              if stu.updated_at > entry.date_modified
                # This one is newer than the OldDb one
                # puts("case 1") if Rails.env.development? || Rails.env.test?
                entry.common_name = stu.name
                entry.department = stu.department.sync_id
                entry.FYPyear = stu.fyp_year
                unless entry.save && stu.touch
                  errors_text.append('[OldDB Student] Sync failed on: ' + entry.values.to_s)
                  errors_text.append(entry.errors.full_messages)
                  errors += 1
                end
              else
                # The OldDb one is newer
                # puts("case 2") if Rails.env.development? || Rails.env.test?
                stu.name = entry.common_name
                stu.department_id = d_id
                stu.fyp_year = @fyp_year
                if stu.changed.blank?
                  stu.touch && entry.touch
                else
                  unless stu.save && entry.touch
                    errors_text.append('[Student] Sync failed on: ' + stu.attributes.to_s)
                    errors_text.append(stu.errors.full_messages)
                    errors += 1
                  end
                end
              end
            else
              # The old one is deleted, and new one created with the same netID
              # puts("case 3") if Rails.env.development?
              stu.destroy
              new_stu = Student.new(netID: entry.net_id, name: entry.common_name, department_id: d_id, fyp_year: @fyp_year, sync_id: entry.id)
              unless new_stu.save && entry.touch
                errors_text.append('[New Student] Sync failed on: ' + new_stu.attributes.to_s)
                errors_text.append(new_stu.errors.full_messages)
                errors += 1
              end
            end
          else
            # Totally new
            # puts("case 4") if Rails.env.development?
            new_stu = Student.new(netID: entry.net_id, name: entry.common_name, department_id: d_id, fyp_year: @fyp_year, sync_id: entry.id)
            unless new_stu.save && entry.touch
              errors_text.append('[New Student] Sync failed on: ' + new_stu.attributes.to_s)
              errors_text.append(new_stu.errors.full_messages)
              errors += 1
            end
          end
        elsif entry.role == '2'
          # is a supervisor
          sup = synced_supervisors.select { |x| x.netID == entry.net_id }.first
          if sup.present?
            if sup.sync_id == entry.id
              next if (sup.updated_at - entry.date_modified).abs < 1

              if entry.date_modified.blank? || sup.updated_at > entry.date_modified
                # This one is newer than the OldDb one
                # puts("case 1") if Rails.env.development?
                entry.common_name = sup.name
                entry.department = sup.department.sync_id
                unless entry.save && sup.touch
                  errors_text.append('[OldDB Supervisor] Sync failed on: ' + entry.values.to_s)
                  errors_text.append(entry.errors.full_messages)
                  errors += 1
                end
              else
                # The OldDb one is newer
                # puts("case 2") if Rails.env.development?
                sup.name = entry.common_name
                sup.department_id = d_id
                if sup.changed.blank?
                  sup.touch && sup.touch
                else
                  unless sup.save && entry.touch
                    errors_text.append('[Supervisor] Sync failed on: ' + sup.attributes.to_s)
                    errors_text.append(sup.errors.full_messages)
                    errors += 1
                  end
                end
              end
            else
              # The old one is deleted, and new one created with the same netID
              # puts("case 3") if Rails.env.development?
              sup.destroy
              new_sup = Supervisor.new(netID: entry.net_id, name: entry.common_name, department_id: d_id, sync_id: entry.id)
              unless new_sup.save && entry.touch
                errors_text.append('[New Supervisor] Sync failed on: ' + new_sup.attributes.to_s)
                errors_text.append(new_sup.errors.full_messages)
                errors += 1
              end
            end
          else
            # Totally new
            # puts("case 4") if Rails.env.development?
            new_sup = Supervisor.new(netID: entry.net_id, name: entry.common_name, department_id: d_id, sync_id: entry.id)
            unless new_sup.save && entry.touch
              errors_text.append('[New Supervisor] Sync failed on: ' + new_sup.attributes.to_s)
              errors_text.append(new_sup.errors.full_messages)
              errors += 1
            end
          end
        end
      end

      Student.where(sync_id: nil).each do |stu|
        old_stu = OldUser.new(common_name: stu.name, net_id: stu.netID, department: stu.department.sync_id, FYPyear: stu.fyp_year, status: 1, role: 1, uuid: 0, program_code: 0, subject_code: 0, senior_year: 0)
        if !old_stu.save
          errors_text.append('[New OldDB Student] Sync failed on: ' + old_stu.values.to_s)
          errors_text.append(old_stu.errors.full_messages)
          errors += 1
        else
          stu.sync_id = old_stu.id
          unless stu.save
            errors_text.append('[New OldDB Student] SyncID update failed on: ' + old_stu.values.to_s)
            errors_text.append(stu.errors.full_messages)
            errors += 1
          end
        end
      end

      Supervisor.where(sync_id: nil).each do |sup|
        old_sup = OldUser.new(common_name: sup.name, net_id: sup.netID, department: sup.department.sync_id, status: 1, role: 2, uuid: 0, program_code: 0, subject_code: 0, senior_year: 0)
        if !old_sup.save
          errors_text.append('[New OldDB Supervisor] Sync failed on: ' + old_sup.values.to_s)
          errors_text.append(old_sup.errors.full_messages)
          errors += 1
        else
          sup.sync_id = old_sup.id
          unless sup.save
            errors_text.append('[New OldDB Supervisor] SyncID update failed on: ' + old_sup.values.to_s)
            errors_text.append(sup.errors.full_messages)
            errors += 1
          end
        end
      end

      # Update Relations according to old DB
      puts('Updating Relations...') unless Rails.env.test?
      OldRelation.each do |old_rel|
        next if old_rel.status != 1

        if OldUser[old_rel.student_net_id.to_i]
          stu = Student.find_by(sync_id: old_rel.student_net_id.to_i)
        end
        if OldUser[old_rel.supervisor_net_id.to_i]
          sup = Supervisor.find_by(sync_id: old_rel.supervisor_net_id.to_i)
        end
        if stu && sup && !stu.supervisors.find_by(id: sup.id)
          stu.supervisors << sup
        elsif !OldUser[old_rel.student_net_id.to_i] || !OldUser[old_rel.supervisor_net_id.to_i]
          # Delete if relation is invalid
          puts('Relation ' + old_rel.values.to_s + ' deleted because student or supervisor does not exist')
          old_rel.destroy
        end
      end

      # Update Todos according to old DB
      puts('Updating Todos...') unless Rails.env.test?
      Todo.where.not(sync_id: nil).where.not(sync_id: OldTodo.where(status: 1).pluck(:id)).each(&:destroy)

      synced_todos = Todo.where(sync_id: OldTodo.where(status: 1).pluck(:id))
      OldTodo.each do |old_todo|
        next if old_todo.status != 1

        if old_todo.issued_department.present?
          dep = synced_departments.select { |x| x.sync_id == old_todo.issued_department }.first
          department_id = (dep.present? ? dep.id : nil)
        else
          department_id = nil
        end

        if old_todo.time.blank? || old_todo.title.blank?
          puts('OldTodo item deleted because time/title is not set. ' + old_todo.values.to_s)
          old_todo.destroy
          next
        end

        todo = synced_todos.select { |x| x.sync_id == old_todo.id }.first
        if todo.present?
          next if (todo.updated_at - old_todo.date_modified).abs < 1

          if old_todo.scope != 1
            # Remove Todo unrelated to department
            todo.destroy
          elsif old_todo.date_modified.blank? || todo.updated_at > old_todo.date_modified
            # Ours is newer
            # puts("case 1") if Rails.env.development?
            old_todo.title = todo.title
            old_todo.description = todo.description
            old_todo.issued_department = (todo.department.present? ? todo.department.sync_id : nil)
            old_todo.time = todo.eta.in_time_zone
            unless old_todo.save && todo.touch
              errors_text.append('[OldDB Todo] Sync failed on: ' + old_todo.values.to_s)
              errors_text.append(old_todo.errors.full_messages)
              errors += 1
            end
          else
            # OldDb one is newer
            # puts("case 2") if Rails.env.development?
            todo.title = old_todo.title
            todo.description = old_todo.description
            todo.department_id = department_id
            todo.eta = old_todo.time
            if todo.changed.blank?
              todo.touch && old_todo.touch
            else
              unless todo.save && old_todo.touch
                errors_text.append('[Todo] Sync failed on: ' + todo.attributes.to_s)
                errors_text.append(todo.errors.full_messages)
                errors += 1
              end
            end
          end
        elsif old_todo.scope == 1
          # Totally new
          puts('case 3') if Rails.env.development?
          new_todo = Todo.new(title: old_todo.title, description: old_todo.description, department_id: department_id, eta: old_todo.time, sync_id: old_todo.id)
          unless new_todo.save && old_todo.touch
            errors_text.append('[Todo] Sync failed on: ' + new_todo.attributes.to_s)
            errors_text.append(new_todo.errors.full_messages)
            errors += 1
          end
        end
      end

      Todo.where(sync_id: nil).each do |todo|
        old_todo = OldTodo.new(title: todo.title, description: todo.description, issued_department: (todo.department.present? ? todo.department.sync_id : nil), time: todo.eta, scope: 1, status: 1)
        if !old_todo.save
          errors_text.append('[New OldDB Todo] Sync failed on: ' + old_todo.values.to_s)
          errors_text.append(old_todo.errors.full_messages)
          errors += 1
        else
          todo.sync_id = old_todo.id
          unless todo.save
            errors_text.append('[New OldDB Todo] SyncID update failed on: ' + old_todo.values.to_s)
            errors_text.append(todo.errors.full_messages)
            errors += 1
          end
        end
      end

      puts('---------------------------------------------') unless Rails.env.test?
      errors_text.each do |text|
        puts(text) unless Rails.env.test?
      end
      raise format('OldDb sync failed with %d %s.', errors, 'error'.pluralize(errors)) if (errors > 0) && Rails.env.production?

      return format('Completed with %d %s.', errors, 'error'.pluralize(errors))
    end
  end
end
