# frozen_string_literal: true

class StudentsController < ApplicationController
  before_action :authenticate_user!
  def index
    if is_admin?
      @students = Student.all.includes(:department, :supervisors)
      @departments_list = get_departments_list
    else
      @students = Student.where(department: current_user.department).includes(:department, :supervisors)
    end
    @fyp_year_list = get_fyp_years_list
    @student = Student.new
    respond_to do |format|
      format.html
      format.json do
        render json: { data: @students }
      end
    end
  end

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(student_params)
    if Student.find_by(netID: params[:netID])
      flash[:danger] = Array(flash[:danger]).push('Student with this netID already exist.')
      if is_admin?
        @students = Student.all
        @departments_list = get_departments_list
      else
        @students = Student.where(department: current_user.department)
      end
      @fyp_year_list = get_fyp_years_list
      render 'index'
      return
    end
    if @student.save
      sync_id = olddb_student_create(student_params)
      @student.sync_id = sync_id
      @student.save
      flash[:success] = Array(flash[:success]).push('Student successfully added!')
      redirect_to '/students'
    else
      if params[:department_id] == ''
        flash.now[:danger] = Array(flash.now[:danger]).push("Please select the student's department.")
      elsif params[:fyp_year] == ''
        flash.now[:danger] = Array(flash.now[:danger]).push('Student must have an FYP Year.')
      elsif params[:netID] = ''
        flash.now[:danger] = Array(flash.now[:danger]).push('Student must have a netID.')
      else
        flash.now[:danger] = Array(flash.now[:danger]).push('Error when creating student.')
      end
      if is_admin?
        @students = Student.all
        @departments_list = get_departments_list
      else
        @students = Student.where(department: current_user.department)
      end
      @fyp_year_list = get_fyp_years_list
      render 'index'
    end
  end

  def student_params
    params.require(:student).permit(:name, :netID, :department_id, :fyp_year)
  end

  def edit
    @student = Student.find(params[:id])
    @departments_list = get_departments_list
    @fyp_year_list = get_fyp_years_list
  end

  def update
    if request.patch?
      @student = Student.find(params[:id])
      if @student.update_attributes(student_params)
        @student.sync_id ? olddb_student_update(student_params) : false
        flash[:success] = Array(flash[:success]).push('Student updated.')
        redirect_to '/students'
      else
        flash.now[:danger] = Array(flash.now[:danger]).push('Error updating student.')
        render 'update'
      end
    end
  end

  def destroy
    sync_id = Student.find(params[:id]).sync_id
    if Student.find(params[:id]).destroy
      sync_id ? olddb_student_destroy(sync_id) : false
      flash[:success] = Array(flash[:success]).push('Student deleted.')
    else
      flash[:danger] = Array(flash[:danger]).push('Error deleting student.')
    end
    redirect_to '/students'
  end

  def removeSupervisor
    sup_netid = request.params[:sup_netID]
    stu_netid = request.params[:stu_netID]
    @student = Student.find_by(netID: stu_netid)
    sup = Supervisor.find_by(netID: sup_netid)
    if !@student
      flash[:danger] = Array(flash[:danger]).push('Student not found')
      redirect_back(fallback_location: students_url)
    elsif !sup
      flash[:danger] = Array(flash[:danger]).push('Supervisor not found')
      redirect_back(fallback_location: students_url)
    else
      @student.supervisors.delete(sup)
      @student.sync_id && sup.sync_id ? olddb_student_removeSupervisor(stu_netid, sup_netid) : false
      flash[:success] = Array(flash[:success]).push('Supervisor removed successfully.')
      redirect_back(fallback_location: students_url)
    end
  end

  def batch_import
    @student = Student.new
    @fyp_year_list = get_fyp_years_list
    @departments_list = get_departments_list if is_admin?

    if request.post?
      flash[:students_list] = request.params[:students_list]
      netID_list = request.params[:students_list][:netID_list].lines.each(&:strip!)
      name_list = request.params[:students_list][:name_list].lines.each(&:strip!)
      department_id = request.params[:students_list][:department_id]
      fyp_year = request.params[:students_list][:fyp_year]
      if name_list.length != netID_list.length
        flash.now[:danger] = Array(flash.now[:danger]).push("Length of NetIDs does not match length of names. Press Enter to skip line if name isn't available.")
        render 'batch_import'
        return
      end
      if name_list.length > netID_list.length
        flash.now[:danger] = Array(flash.now[:danger]).push('Every student must have a netID.')
        render 'batch_import'
        return
      end
      if fyp_year == ''
        flash.now[:danger] = Array(flash.now[:danger]).push('Please select FYP year of the student(s).')
        render 'batch_import'
        return
      end
      if department_id == ''
        flash.now[:danger] = Array(flash.now[:danger]).push('Please select the Department of the student(s).')
        render 'batch_import'
        return
      end
      if netID_list.empty?
        flash.now[:danger] = Array(flash.now[:danger]).push('Please enter student(s) info.')
        render 'batch_import'
        return
      end
      netID_list.zip(name_list).each do |netID, name|
        if Student.find_by(netID: netID)
          flash.now[:danger] = Array(flash.now[:danger]).push('Student with netID: ' + netID + ' already exist.')
          render 'batch_import'
          return
        end
        @student = Student.new(department_id: department_id, fyp_year: fyp_year, netID: netID, name: name)
        if !@student.save
          flash[:danger] = Array(flash[:danger]).push('Error when saving student ' + netID.to_s)
          render 'batch_import'
          return
        else
          sync_id = olddb_student_create(department_id: department_id, fyp_year: fyp_year, netID: netID, name: name)
          @student.sync_id = sync_id
          @student.save
        end
      end
      flash[:success] = Array(flash[:success]).push('All students successfully created.')
      flash.delete(:students_list)
      redirect_to '/students'
    end
  end

  def olddb_student_create(params)
    @old_student = OldUser.create(common_name: params[:name], net_id: params[:netID], FYPyear: params[:fyp_year], department: Department.find(params[:department_id]).sync_id, status: 1, role: 1, uuid: 0, program_code: 0, subject_code: 0, senior_year: 0)
    @old_student.id
  end

  def olddb_student_update(params)
    @old_student = OldUser.first(net_id: params[:netID])
    @old_student.update(common_name: params[:name], net_id: params[:netID], FYPyear: params[:fyp_year], department: Department.find(params[:department_id]).sync_id)
  end

  def olddb_student_destroy(sync_id)
    @old_student = OldUser[sync_id]
    @old_student.destroy
  end

  def olddb_student_removeSupervisor(stu_netID, sup_netID)
    @old_student = OldUser.first(net_id: stu_netID)
    @old_supervisor = OldUser.first(net_id: sup_netID)
    @old_rel = OldRelation.first(student_net_id: @old_student.id, supervisor_net_id: @old_supervisor.id)
    @old_rel.destroy
  end
end
