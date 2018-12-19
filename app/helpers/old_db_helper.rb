module OldDbHelper
    def check_old_department(dep_name)
        @dep = OldDepartments.first(name: dep_name)
        if !@dep
            @dep = OldDepartments.create(name: dep_name, status: 1)
        end
        return @dep.id
    end
end