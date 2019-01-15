# frozen_string_literal: true

class SupervisorsController < ApplicationController
  before_action :authenticate_user!
  def index
    if is_admin?
      @supervisors = Supervisor.all
      @departments_list = get_departments_list
    else
      @supervisors = Supervisor.where(department: current_user.department)
    end
    @supervisor = Supervisor.new
  end

  def new
    @supervisor = Supervisor.new
  end

  def create
    @supervisor = Supervisor.new(supervisor_params)
    if @supervisor.save
      sync_id = olddb_supervisor_create(supervisor_params)
      @supervisor.sync_id = sync_id
      @supervisor.save
      flash[:success] = Array(flash[:success]).push('Supervisor successfully added!')
      redirect_to '/supervisors'
    else
      if params[:department_id] == ''
        flash.now[:danger] = Array(flash.now[:danger]).push("Please select the supervisor's department.")
      elsif params[:name] == ''
        flash.now[:danger] = Array(flash.now[:danger]).push('Supervisor must have a name.')
      else
        flash.now[:danger] = Array(flash.now[:danger]).push('Error when creating supervisor.')
      end
      if is_admin?
        @supervisors = Supervisor.all
        @departments_list = get_departments_list
      else
        @supervisors = Supervisor.where(department: current_user.department)
      end
      render 'index'
    end
  end

  def supervisor_params
    params.require(:supervisor).permit(:name, :netID, :department_id)
  end

  def edit
    @supervisor = Supervisor.find(params[:id])
    @departments_list = get_departments_list
  end

  def update
    if request.patch?
      @supervisor = Supervisor.find(params[:id])
      if @supervisor.update_attributes(supervisor_params)
        @supervisor.sync_id ? olddb_supervisor_update(supervisor_params) : false
        flash[:success] = Array(flash[:success]).push('Supervisor updated.')
        redirect_to '/supervisors'
      else
        flash.now[:danger] = Array(flash.now[:danger]).push('Error updating supervisor.')
        render 'update'
      end
    end
    end

  def destroy
    sync_id = Supervisor.find(params[:id]).sync_id
    if Supervisor.find(params[:id]).destroy
      sync_id ? olddb_supervisor_destroy(sync_id) : false
      flash[:success] = Array(flash[:success]).push('Supervisor deleted.')
    else
      flash[:danger] = Array(flash[:danger]).push('Error deleting supervisor.')
    end
    redirect_to '/supervisors'
  end

  def removeStudent
    sup_netid = request.params[:sup_netID]
    stu_netid = request.params[:stu_netID]
    @supervisors = Supervisor.all
    @supervisor = Supervisor.find_by(netID: sup_netid)
    stu = Student.find_by(netID: stu_netid)
    if !@supervisor
      flash[:danger] = Array(flash[:danger]).push('Supervisor not found.')
      redirect_to '/supervisors'
    elsif !stu
      flash[:danger] = Array(flash[:danger]).push('Student not found.')
      redirect_to '/supervisors'
    else
      @supervisor.students.delete(stu)
      @supervisor.sync_id && stu.sync_id ? olddb_supervisor_removeStudent(stu_netid, sup_netid) : false
      flash[:success] = Array(flash[:success]).push('Student unassigned successfully.')
      redirect_to '/supervisors'
    end
  end

  def batch_import
    @supervisor = Supervisor.new
    @departments_list = get_departments_list if is_admin?

    if request.post?
      flash[:supervisors_list] = request.params[:supervisors_list]
      netID_list = request.params[:supervisors_list][:netID_list].lines.each(&:strip!)
      name_list = request.params[:supervisors_list][:name_list].lines.each(&:strip!)
      department_id = request.params[:supervisors_list][:department_id]
      if name_list.length < netID_list.length
        flash.now[:danger] = Array(flash.now[:danger]).push('Every supervisor must have a name.')
        render 'batch_import'
        return
      end
      if name_list.length > netID_list.length
        flash.now[:danger] = Array(flash.now[:danger]).push('Every supervisor must have a netID.')
        render 'batch_import'
        return
      end
      if department_id == ''
        flash.now[:danger] = Array(flash.now[:danger]).push('Please select the Department of the supervisor(s).')
        render 'batch_import'
        return
      end
      if netID_list.empty?
        flash.now[:danger] = Array(flash.now[:danger]).push('Please enter supervisor(s) info.')
        render 'batch_import'
        return
      end
      netID_list.zip(name_list).each do |netID, name|
        if Supervisor.find_by(netID: netID)
          flash.now[:danger] = Array(flash.now[:danger]).push('Supervisor with netID: ' + netID + ' already exist.')
          render 'batch_import'
          return
        end
        @supervisor = Supervisor.new(department_id: department_id, netID: netID, name: name)
        if !@supervisor.save
          if name == ''
            flash[:danger] = Array(flash[:danger]).push('Supervisor ' + netID.to_s + ' must have a name.')
          else
            flash[:danger] = Array(flash[:danger]).push('Error when saving supervisor ' + netID.to_s)
          end
          render 'batch_import'
          return
        else
          sync_id = olddb_supervisor_create(department_id: department_id, netID: netID, name: name)
          @supervisor.sync_id = sync_id
          @supervisor.save
        end
      end
      flash[:success] = Array(flash[:success]).push('All supervisors successfully created.')
      flash.delete(:supervisors_list)
      redirect_to '/supervisors'
    end
  end

  def olddb_supervisor_create(params)
    @old_supervisor = OldUser.create(common_name: params[:name], net_id: params[:netID], department: Department.find(params[:department_id]).sync_id, status: 1, role: 2, uuid: 0, program_code: 0, subject_code: 0, senior_year: 0)
    @old_supervisor.id
  end

  def olddb_supervisor_update(params)
    @old_supervisor = OldUser.first(net_id: params[:netID])
    @old_supervisor.update(common_name: params[:name], net_id: params[:netID], department: Department.find(params[:department_id]).sync_id)
  end

  def olddb_supervisor_destroy(sync_id)
    @old_supervisor = OldUser[sync_id]
    @old_supervisor.destroy
  end

  def olddb_supervisor_removeStudent(stu_netID, sup_netID)
    @old_student = OldUser.first(net_id: stu_netID)
    @old_supervisor = OldUser.first(net_id: sup_netID)
    @old_rel = OldRelation.first(student_net_id: @old_student.id, supervisor_net_id: @old_supervisor.id)
    @old_rel.destroy
  end
end
