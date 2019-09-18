# frozen_string_literal: true

class TodosController < ApplicationController
  before_action :authenticate_user!
  def index
    if is_admin?
      @universities_list = get_universities_list
      @todo_list = Todo.all.order('eta ASC').includes(:department)
    else
      @todo_list = Todo.where(department: current_user.department).or(Todo.where(department: nil)).order('eta ASC').includes(:department)
    end
    @todo = Todo.new
    @departments_list = get_departments_list unless request.format.json?
    respond_to do |format|
      format.html
      format.json do
        render json: @todo_list
      end
    end
  end

  def create
    params[:todo][:department_id] = current_user.department.id unless is_admin?
    @todo = Todo.new(todo_params)
    if @todo.save
      sync_id = olddb_todo_create(todo_params)
      @todo.sync_id = sync_id
      @todo.save
      flash.now[:success] = Array(flash.now[:success]).push('Todo item successfully added!')
      @todo = Todo.new
    else
      if request.params[:todo][:eta].blank?
        flash.now[:danger] = Array(flash.now[:danger]).push('Todo date cannot be empty. Please set date.')
      elsif request.params[:todo][:title].blank?
        flash.now[:danger] = Array(flash.now[:danger]).push('Todo title cannot be empty. Please enter title.')
      else
        flash.now[:danger] = Array(flash.now[:danger]).push('Create todo item unsuccessful.')
      end
      @retry = true
    end
    if is_admin?
      @todo_list = Todo.all.order('eta ASC')
    else
      @todo_list = Todo.where(department: current_user.department).or(Todo.where(department: nil)).order('eta ASC')
    end
    @departments_list = get_departments_list
    @universities_list = get_universities_list if is_admin?
    render 'index'
  end

  def edit
    @todo = Todo.find(params[:id])
    @departments_list = get_departments_list(@todo.university_id) if is_admin?
    @universities_list = get_universities_list if is_admin?
  end

  def update
    @todo = Todo.find(params[:id])
    if request.patch?
      if @todo.update(todo_params)
        @todo.sync_id ? olddb_todo_update(todo_params, @todo.sync_id) : false
        flash[:success] = Array(flash[:success]).push('Todo item updated.')
        redirect_to todos_url
      else
        if request.params[:todo][:eta].blank?
          flash.now[:danger] = Array(flash.now[:danger]).push('Todo date cannot be empty. Please set date.')
        elsif request.params[:todo][:title].blank?
          flash.now[:danger] = Array(flash.now[:danger]).push('Todo title cannot be empty. Please enter title.')
        else
          flash.now[:danger] = Array(flash.now[:danger]).push('Error when updating Todo item.')
        end
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
      flash.now[:success] = Array(flash.now[:success]).push('Todo item deleted.')
      render plain: 'submitted'
    else
      flash.now[:danger] = Array(flash.now[:danger]).push('Error when deleting Todo item.')
      render plain: 'failed'
    end
  end

  def olddb_todo_create(params)
    @old_todo = OldTodo.create(issued_department: (params[:department_id].present? ? Department.find(params[:department_id]).sync_id : nil), status: 1, title: params[:title].squish, scope: 1, time: params[:eta], description: params[:description])
    @old_todo.id
  end

  def olddb_todo_update(params, sync_id)
    @old_todo = OldTodo[sync_id]
    return if @old_todo.blank?

    @old_todo.update(issued_department: (params[:department_id].present? ? Department.find(params[:department_id]).sync_id : nil), status: 1, title: params[:title].squish, time: params[:eta], description: params[:description])
  end

  def olddb_todo_destroy(sync_id)
    @old_todo = OldTodo[sync_id]
    return if @old_todo.blank?

    @old_todo.update(status: 2)
  end
end
