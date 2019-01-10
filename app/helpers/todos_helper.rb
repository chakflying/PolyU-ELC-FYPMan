module TodosHelper
    include OldDbHelper

    def olddb_todo_create(params)
        @old_todo = OldTodos.create(issued_department: check_old_department(Department.find(params[:department_id]).name), status: 1, title: params[:title], time: params[:eta], description: params[:description])
        return @old_todo.id
    end

    def olddb_todo_update(params, sync_id)
        @old_todo = OldTodos[sync_id]
        @old_todo.update(issued_department: check_old_department(Department.find(params[:department_id]).name), status: 1, title: params[:title], time: params[:eta], description: params[:description])
    end

    def olddb_todo_destroy(sync_id)
        @old_todo = OldTodos[sync_id]
        @old_todo.destroy
    end
end
