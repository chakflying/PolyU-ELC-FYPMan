class TodosController < ApplicationController
    before_action :authenticate_user!
    def index
        if is_admin?
            @todo_list = Todo.all.order("eta ASC")
        else
            @todo_list = Todo.where(department: current_user.department).or(Todo.where(department: nil)).order("eta ASC")
        end
        @todo = Todo.new
        @departments_list = get_departments_list
        respond_to do |format|
            format.html
            format.json {
              render json: @todo_list
            }
        end
    end

    def create
        @todo = Todo.new(todo_params)  # Not the final implementation!
        if @todo.save
            sync_id = olddb_todo_create(todo_params)
            @todo.sync_id = sync_id
            @todo.save
            flash.now[:success] = Array(flash.now[:success]).push("Todo item successfully added!")
        else
            if request.params[:eta].nil?
                flash.now[:danger] = Array(flash.now[:danger]).push("Todo date cannot be empty. Please set date.")
            else
                flash.now[:danger] = Array(flash.now[:danger]).push("Create todo item unsuccessful.")
            end
        end
        if is_admin?
            @todo_list = Todo.all.order("eta ASC")
        else
            @todo_list = Todo.where(department: current_user.department).or(Todo.where(department: nil)).order("eta ASC")
        end
        @todo = Todo.new
        @departments_list = get_departments_list
        render 'index'
    end

    def edit
        @todo = Todo.find(params[:id])
        @departments_list = get_departments_list
    end

    def update
        @todo = Todo.find(params[:id])
        if request.patch?
            if @todo.update_attributes(todo_params)
                @todo.sync_id ? olddb_todo_update(todo_params, @todo.sync_id) : false
                flash[:success] = Array(flash[:success]).push("Todo item updated.")
                redirect_to '/todos'
            else
                flash.now[:danger] = Array(flash.now[:danger]).push("Error when updating Todo item.")
                @departments_list = get_departments_list
                render 'edit'
            end
        end
    end

    def todo_params
        params.require(:todo).permit(:department_id, :title, :description, :eta, :color)
    end

    def destroy
        sync_id = Todo.find(params[:id]).sync_id
        if Todo.find(params[:id]).destroy
            sync_id ? olddb_todo_destroy(sync_id) : false
            flash.now[:success] = Array(flash.now[:success]).push("Todo item deleted.")
            render plain: "submitted"
        else
            flash.now[:danger] = Array(flash.now[:danger]).push("Error when deleting Todo item.")
            render plain: "failed"
        end
    end

    def olddb_todo_create(params)
        @old_todo = OldTodos.create(issued_department: Department.find(params[:department_id]).sync_id, status: 1, title: params[:title], time: params[:eta], description: params[:description])
        return @old_todo.id
    end

    def olddb_todo_update(params, sync_id)
        @old_todo = OldTodos[sync_id]
        @old_todo.update(issued_department: Department.find(params[:department_id]).sync_id, status: 1, title: params[:title], time: params[:eta], description: params[:description])
    end

    def olddb_todo_destroy(sync_id)
        @old_todo = OldTodos[sync_id]
        @old_todo.destroy
    end
end
