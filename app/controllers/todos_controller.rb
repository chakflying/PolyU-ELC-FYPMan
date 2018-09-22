class TodosController < ApplicationController
    before_action :authenticate_user!
    def show
        if is_admin?
            @todolist = Todo.all.order("eta ASC").to_a
        else
            @todolist = Todo.where(department: current_user.department).or(Todo.where(department: "")).order("eta ASC").to_a
        end
        @todo = Todo.new
        @departments_list = get_departments_list
    end

    def create
        @todo = Todo.new(todo_params)  # Not the final implementation!
        if @todo.save
            flash[:success] = "Todo item successfully added!"
            redirect_to '/todos'
        else
            if request.params[:eta].nil?
                flash[:danger] = "Todo date cannot be empty. Please set date."
            else
                flash[:danger] = "Create todo item unsuccessful."
            end
            @todolist = Todo.all
            @todo = Todo.new
            @departments_list = get_departments_list
            render 'show'
        end
    end

    def edit
        @todo = Todo.find(params[:id])
        @departments_list = get_departments_list
    end

    def update
        @todo = Todo.find(params[:id])
        @departments_list = get_departments_list
        if request.patch?
            if @todo.update_attributes(todo_params)
                flash[:success] = "Todo item updated."
                redirect_to '/todos'
            else
                render 'update'
            end
        end
    end

    def todo_params
        params.require(:todo).permit(:department, :title, :description, :eta)
    end

    def destroy
        if Todo.find(params[:id]).destroy
            flash[:success] = "Todo item deleted."
            render plain: "submitted"
        else
            flash[:alert] = "No todo item deleted."
            render plain: "failed"
        end
    end
end
