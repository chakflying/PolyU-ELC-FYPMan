class OldDb < ActiveRecord::Base  
    # self.abstract_class = true
    if Rails.env.development?
        establish_connection "development_old".to_sym
    elsif Rails.env.production?
        establish_connection "production_old".to_sym
    end

    def self.sync
        if Rails.env.development?
            establish_connection "development_old".to_sym
        elsif Rails.env.production?
            establish_connection "production_old".to_sym
        end
        entries = self.connection.select_all("SELECT * FROM users")
        departments = self.connection.select_all("SELECT * from departments")
        relations = self.connection.select_all("SELECT * from supervises")
        todos = self.connection.select_all("SELECT * from todos")
        entries.each do |entry|
            next if entry['status'] == 0
            if entry['FYPyear'] == nil or entry['FYPyear'] == ""
                @fyp_year = Time.now.year.to_s + '-' + (Time.now.year + 1).to_s
            else
                @fyp_year = entry['FYPyear']
            end
            if entry['department'] != nil
                @department = departments.detect{|x| x['id'] == entry['department']}['name']
            else
                @department = ""
            end
            if entry['role'] == "1"
                # is a student
                if(!Student.find_by(netID: entry['net_id']))
                    @student = Student.new(netID: entry['net_id'], name: entry['common_name'], department: @department, fyp_year: @fyp_year, sync_id: entry['id'])
                    @student.save!
                end
            elsif entry['role'] == "2"
                # is a supervisor
                if(!Supervisor.find_by(netID: entry['net_id']))
                    @supervisor = Supervisor.new(netID: entry['net_id'], name: entry['common_name'], department: @department, sync_id: entry['id'])
                    @supervisor.save!
                end
            end
        end
        Student.where.not(sync_id: nil) do |student|
            stu = entries.detect{|x| x['id'] == student.sync_id}
            if (stu == nil)
                student.delete
            else
                student.department = ( stu['department'] ? departments.detect{|x| x['id'] == stu['department']}['name'] : "" )
                student.name = stu['common_name']
                student.fyp_year = ( ( !stu['FYPyear'] or entry['FYPyear'] == "" ) ? Time.now.year.to_s + '-' + (Time.now.year + 1).to_s : stu['FYPyear'])
                student.netID = stu['net_id']
                student.save!
            end
        end
        Supervisor.where.not(sync_id: nil) do |supervisor|
            sup = entries.detect{|x| x['id'] == supervisor.sync_id}
            if (sup == nil)
                supervisor.delete
            else
                supervisor.department = ( sup['department'] ? departments.detect{|x| x['id'] == sup['department']}['name'] : "" )
                supervisor.name = sup['common_name']
                supervisor.netID = sup['net_id']
                supervisor.save!
            end
        end
        relations.each do |rel|
            next if rel['status'] == 0
            if (entries.detect{|x| x['id'] == rel['student_net_id'].to_i})
                @stu = Student.find_by(netID: entries.detect{|x| x['id'] == rel['student_net_id'].to_i}['net_id'])
            end
            if (entries.detect{|x| x['id'] == rel['supervisor_net_id'].to_i})
                @sup = Supervisor.find_by(netID: entries.detect{|x| x['id'] == rel['supervisor_net_id'].to_i}['net_id'])
            end
            if (@stu && @sup && !@stu.supervisors.find_by(id: @sup.id))
                @stu.supervisors << @sup
            end
        end
        todos.each do |in_todo|
            next if in_todo['status'] == 0
            @todo = Todo.find_by(sync_id: in_todo['id'])
            if in_todo['issued_department'] != nil
                @department = departments.detect{|x| x['id'] == in_todo['issued_department']}['name']
            else
                @department = ""
            end
            if @todo != nil
                @todo.title = in_todo['title']
                @todo.description = in_todo['description']
                @todo.department = @department
                @todo.eta = in_todo['time']
                @todo.save!
            else
                @todo = Todo.new(title: in_todo['title'], description: in_todo['description'], department: @department, eta: in_todo['time'], sync_id: in_todo['id'])
                @todo.save!
            end
        end
        Todo.where.not(sync_id: nil) do |todo_item|
            @todo = todos.detect{|x| x['id'] == todo_item.sync_id}
            if @todo == nil
                todo_item.delete
            end
        end
    end
end