# frozen_string_literal: true

class DepartmentsController < ApplicationController
  before_action :authenticate_admin_404!

  def index
    @departments = Department.all.includes(:faculty).references(:faculty)
    @department = Department.new
    @faculties_list = get_faculties_list
  end

  def new
    @department = Department.new
  end

  def create
    @department = Department.new(department_params)
    if @department.save
      sync_id = olddb_department_create(department_params)
      @department.sync_id = sync_id
      @department.save
      flash[:success] = Array(flash[:success]).push('Department successfully added.')
      @department = Department.new
      redirect_to departments_url
    else
      if params[:department][:name].blank?
        flash.now[:danger] = Array(flash.now[:danger]).push("Please enter department's name.")
      elsif params[:department][:code].blank?
        flash.now[:danger] = Array(flash.now[:danger]).push("Please enter department's code.")
      else
        flash.now[:danger] = Array(flash.now[:danger]).push('Error when creating department.')
      end
      @departments = Department.all.includes(:faculty).references(:faculty)
      @faculties_list = get_faculties_list
      render 'index'
    end
  end

  def department_params
    params.require(:department).permit(:name, :code, :faculty_id, :university_id, :sync_id)
  end

  def edit
    @department = Department.find(params[:id])
    @faculties_list = get_faculties_list
  end

  def update
    if request.patch?
      @department = Department.find(params[:id])
      if @department.update_attributes(department_params)
        if @department.sync_id.present?
          olddb_department_update(department_params)
        else
          sync_id = olddb_department_create(department_params)
          @department.sync_id = sync_id
          @department.save!
        end
        flash[:success] = Array(flash[:success]).push('Department info updated.')
        redirect_to departments_url
      else
        if params[:department][:name].blank?
          flash.now[:danger] = Array(flash.now[:danger]).push("Please enter department's name.")
        elsif params[:department][:code].blank?
          flash.now[:danger] = Array(flash.now[:danger]).push("Please enter department's code.")
        else
          flash.now[:danger] = Array(flash.now[:danger]).push('Error updating department info.')
        end
        @faculties_list = get_faculties_list
        render 'edit'
      end
    end
  end

  def destroy
    sync_id = Department.find(params[:id]).sync_id
    if Department.find(params[:id]).destroy
      sync_id ? olddb_department_destroy(sync_id) : false
      flash[:success] = Array(flash[:success]).push('Department deleted.')
    else
      flash[:danger] = Array(flash[:danger]).push('Error deleting department.')
    end
    redirect_to departments_url
  end

  def get_departments_list_by_uni
    @departments_list = []
    if params[:id].blank?
      Department.all.each do |dep|
        @departments_list.push([dep.name, dep.id])
      end
    else
      University.find(params[:id]).faculties.includes(:departments).each do |fac|
        fac.departments.each do |dep|
          @departments_list.push([dep.name, dep.id])
        end
      end
    end
    render json: @departments_list
  end

  def olddb_department_create(params)
    @old_department = OldDepartment.create(name: params[:name].squish, short_name: params[:code], status: 1, faculty: Faculty.find(params[:faculty_id]).sync_id)
    @old_department.id
  end

  def olddb_department_update(params)
    @old_department = OldDepartment[params[:sync_id]]
    return if @old_department.blank?

    @old_department.update(name: params[:name].squish, short_name: params[:code], status: 1, faculty: Faculty.find(params[:faculty_id]).sync_id)
  end

  def olddb_department_destroy(sync_id)
    @old_department = OldDepartment[sync_id]
    return if @old_department.blank?

    @old_department.update(status: 2)
  end
end
