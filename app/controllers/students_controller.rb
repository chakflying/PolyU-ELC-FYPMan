# frozen_string_literal: true

class StudentsController < ApplicationController
  # StudentsController handles various actions of the students page, batch importing students, and
  # the corresponding actions in Old DB.
  before_action :authenticate_user!

  def index
    @departments_list = get_departments_list if is_admin?
    @universities_list = get_universities_list if is_admin?
    @fyp_year_list = get_fyp_years_list
    @student = Student.new
    respond_to do |format|
      format.html
      format.json { render json: StudentDatatable.new(params, admin: is_admin?, current_user_department: current_user.department.id) }
    end
  end

  def new
    @student = Student.new
  end

  def create
    if params[:student][:netID].present? && !params[:student][:netID].include?("@")
      params[:student][:netID] += get_stu_netID_suffix()
    end
    @student = Student.new(student_params)
    if Student.find_by(netID: params[:student][:netID])
      flash.now[:danger] = Array(flash.now[:danger]).push('Student with this netID already exist.')
    elsif @student.save
      sync_id = olddb_student_create(student_params)
      @student.sync_id = sync_id
      @student.save
      flash.now[:success] = Array(flash.now[:success]).push('Student successfully added!')
      @student = Student.new
    else
      if params[:student][:department_id].blank?
        flash.now[:danger] = Array(flash.now[:danger]).push("Please select the student's department.")
      elsif params[:student][:fyp_year].blank?
        flash.now[:danger] = Array(flash.now[:danger]).push('Student must have an FYP Year.')
      elsif params[:student][:netID].blank?
        flash.now[:danger] = Array(flash.now[:danger]).push('Student must have a netID.')
      else
        flash.now[:danger] = Array(flash.now[:danger]).push('Error when creating student.')
      end
    end
    @departments_list = get_departments_list if is_admin?
    @universities_list = get_universities_list if is_admin?
    @fyp_year_list = get_fyp_years_list
    render 'index'
  end

  def student_params
    params.require(:student).permit(:name, :netID, :department_id, :fyp_year)
  end

  def edit
    @student = Student.find(params[:id])
    @departments_list = get_departments_list(@student.university_id) if is_admin?
    @universities_list = get_universities_list if is_admin?
    @fyp_year_list = get_fyp_years_list
  end

  def update
    if request.patch?
      if params[:student][:netID].present? && !params[:student][:netID].include?("@")
        params[:student][:netID] += get_stu_netID_suffix()
      end
      @student = Student.find(params[:id])
      if @student.update(student_params)
        @student.sync_id ? olddb_student_update(student_params) : false
        flash[:success] = Array(flash[:success]).push('Student updated.')
        redirect_to students_url
      else
        if params[:student][:department_id].blank?
          flash.now[:danger] = Array(flash.now[:danger]).push("Please select the student's department.")
        elsif params[:student][:fyp_year].blank?
          flash.now[:danger] = Array(flash.now[:danger]).push('Student must have an FYP Year.')
        elsif params[:student][:netID].blank?
          flash.now[:danger] = Array(flash.now[:danger]).push('Student must have a netID.')
        else
          flash.now[:danger] = Array(flash.now[:danger]).push('Error updating student.')
        end
        @departments_list = get_departments_list(@student.university_id) if is_admin?
        @universities_list = get_universities_list if is_admin?
        @fyp_year_list = get_fyp_years_list
        render 'edit'
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
    redirect_to students_url
  end

  # Model specific unassign function to have customized flash messages.
  def removeSupervisor
    sup_netid = request.params[:sup_netID]
    stu_netid = request.params[:stu_netID]
    @student = Student.find_by(netID: stu_netid)
    sup = Supervisor.find_by(netID: sup_netid)
    if !@student
      flash[:danger] = Array(flash[:danger]).push('Student not found.')
      redirect_to students_url
    elsif !sup
      flash[:danger] = Array(flash[:danger]).push('Supervisor not found.')
      redirect_to students_url
    else
      Supervision.find_by(student_id: @student.id, supervisor_id: sup.id).destroy
      @student.sync_id && sup.sync_id ? olddb_student_removeSupervisor(stu_netid, sup_netid) : false
      flash[:success] = Array(flash[:success]).push('Supervisor removed successfully.')
      redirect_to students_url
    end
  end

  # Function to batch import students. Parses blocks of netID and name data and create each of them if data is valid.
  def batch_import
    @student = Student.new
    @fyp_year_list = get_fyp_years_list
    @departments_list = get_departments_list if is_admin?
    @universities_list = get_universities_list if is_admin?

    if request.post?
      flash[:students_list] = request.params[:students_list]
      netID_list = request.params[:students_list][:netID_list].lines.each(&:strip!)
      name_list = request.params[:students_list][:name_list].lines.each(&:strip!)
      department_id = request.params[:students_list][:department_id]
      fyp_year = request.params[:students_list][:fyp_year]
      if name_list.length != netID_list.length
        flash.now[:danger] = Array(flash.now[:danger]).push(format("Length of netIDs does not match length of names. Press Enter to skip line if name isn't available. [no. of names: %d, no. of netIDs: %d]", name_list.length, netID_list.length))
        render 'batch_import'
        return
      end
      if fyp_year.blank?
        flash.now[:danger] = Array(flash.now[:danger]).push('Please select FYP year of the student(s).')
        render 'batch_import'
        return
      end
      if department_id.blank?
        flash.now[:danger] = Array(flash.now[:danger]).push('Please select the Department of the student(s).')
        render 'batch_import'
        return
      end
      if netID_list.blank?
        flash.now[:danger] = Array(flash.now[:danger]).push('Please enter student(s) info.')
        render 'batch_import'
        return
      end
      netID_list.zip(name_list).each do |netID, name|
        if netID.blank?
          flash.now[:danger] = Array(flash.now[:danger]).push('Every student must have a netID.')
          render 'batch_import'
          return
        end
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
      redirect_to students_url
    end
  end

  def olddb_student_create(params)
    if exist = OldUser[net_id: params[:netID].squish]
      exist.update(common_name: params[:name].squish, net_id: params[:netID].squish, FYPyear: params[:fyp_year], department: Department.find(params[:department_id]).sync_id, status: 1, role: 1, uuid: 0, program_code: 0, subject_code: 0, senior_year: 0)
      exist.id
    else
      @old_student = OldUser.create(common_name: params[:name].squish, net_id: params[:netID].squish, FYPyear: params[:fyp_year], department: Department.find(params[:department_id]).sync_id, status: 1, role: 1, uuid: 0, program_code: 0, subject_code: 0, senior_year: 0)
      @old_student.id
    end
  end

  def olddb_student_update(params)
    @old_student = OldUser.first(net_id: params[:netID].squish)
    return if @old_student.blank?

    @old_student.update(common_name: params[:name].squish, net_id: params[:netID].squish, FYPyear: params[:fyp_year], department: Department.find(params[:department_id]).sync_id)
  end

  def olddb_student_destroy(sync_id)
    @old_student = OldUser[sync_id]
    return if @old_student.blank?

    @old_student.update(status: 0)
  end

  def olddb_student_removeSupervisor(stu_netID, sup_netID)
    @old_student = OldUser.first(net_id: stu_netID)
    @old_supervisor = OldUser.first(net_id: sup_netID)
    @old_rel = OldRelation.first(student_net_id: @old_student.id, supervisor_net_id: @old_supervisor.id)
    return if @old_rel.blank?

    @old_rel.destroy
  end
end
