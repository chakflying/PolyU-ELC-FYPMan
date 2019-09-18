# frozen_string_literal: true

class AssignController < ApplicationController
  before_action :authenticate_user!

  # Assign Function with the relevant existence checks. Parameters tailored for vue component with variable number of students submitted.
  def assign
    # Pass data to Vue frontend
    if is_admin?
      @students = Student.all.select(:netID, :name).to_a
      @supervisors = Supervisor.all.select(:netID, :name).to_a
    else
      @students = Student.where(department: current_user.department).select(:netID, :name).to_a
      @supervisors = Supervisor.where(department: current_user.department).select(:netID, :name).to_a
    end
    # Handle submitted Assign request
    # TODO: can be optimized by using the newer Supervisions model?
    if request.post?
      stu_ids = request.params[:student_netID]
      sup_ids = request.params[:supervisor_netID]
      stu_ids.each do |stu_id|
        if Student.find_by(netID: stu_id).blank?
          flash[:danger] = Array(flash[:danger]).push('Student with netID ' + stu_id + ' not found.')
          stu_ids.delete(stu_id)
        end
      end
      sup_ids.each do |sup_id|
        if Supervisor.find_by(netID: sup_id).blank?
          flash[:danger] = Array(flash[:danger]).push('Supervisor with netID ' + sup_id + ' not found.')
          sup_ids.delete(sup_id)
        end
      end
      stu_ids.each do |stu_id|
        stu = Student.find_by(netID: stu_id)
        sup_ids.each do |sup_id|
          sup = Supervisor.find_by(netID: sup_id)
          if stu.supervisors.find_by(netID: sup_id)
            flash[:info] = Array(flash[:info]).push('Student ' + stu_id + ' already assigned to '+ sup_id +'.')
          else
            stu.supervisors << sup
            olddb_assign(stu_id, sup_id)
            flash[:success] = Array(flash[:success]).push('Student ' + stu_id + ' assigned to ' + sup_id + ' successfully.')
          end
        end
      end
      render plain: 'submitted'
    end
  end

  def ajaxassign
    sup_netid = CGI::unescape(request.params[:supervisor_netID])
    stu_netid = CGI::unescape(request.params[:student_netID])
    stu = Student.find_by(netID: stu_netid)
    sup = Supervisor.find_by(netID: sup_netid)
    if !stu || !sup
      render plain: 'failed'
      return
    else
      Supervision.create(student_id: stu.id, supervisor_id: sup.id)
      stu.sync_id.present? && sup.sync_id.present? ? olddb_assign(stu_netid, sup_netid) : false
      render plain: 'submitted'
    end
  end

  # Ajax Function to unassign student/supervisor.
  def unassign
    sup_netid = CGI::unescape(request.params[:supervisor_netID])
    stu_netid = CGI::unescape(request.params[:student_netID])
    stu = Student.find_by(netID: stu_netid)
    sup = Supervisor.find_by(netID: sup_netid)
    if !stu || !sup
      render plain: 'failed'
      return
    else
      Supervision.find_by(student_id: stu.id, supervisor_id: sup.id).destroy
      stu.sync_id.present? && sup.sync_id.present? ? olddb_unassign(stu_netid, sup_netid) : false
      render plain: 'submitted'
    end
  end

  # Batch Assign Function with the relevant existence checks. Operate on two blocks of text, assign each row.
  def batch_assign
    if request.post?
      flash[:assign_lists] = request.params[:assign_lists]
      students_netID_list = request.params[:assign_lists][:students_list].lines.each(&:strip!)
      supervisors_netID_list = request.params[:assign_lists][:supervisors_list].lines.each(&:strip!)
      if students_netID_list.length != supervisors_netID_list.length
        flash.now[:danger] = Array(flash.now[:danger]).push('The length of two lists is not equal. Check if you need an extra line at the end.')
        render 'batch_assign'
        return
      elsif students_netID_list.blank? || supervisors_netID_list.blank?
        flash.now[:danger] = Array(flash.now[:danger]).push('Please enter student/supervisor info.')
        render 'batch_assign'
        return
      end
      # Verify that all netIDs exist before actual operation
      students_netID_list.zip(supervisors_netID_list).each do |stu_id, sup_id|
        stu = Student.find_by(netID: stu_id)
        sup = Supervisor.find_by(netID: sup_id)
        next if sup && stu

        unless stu then flash.now[:danger] = Array(flash.now[:danger]).push('Student with netID ' + stu_id + ' not found.') end
        unless sup then flash.now[:danger] = Array(flash.now[:danger]).push('Supervisor with netID ' + sup_id + ' not found.') end
        render 'batch_assign'
        return
      end
      students_netID_list.zip(supervisors_netID_list).each do |stu_id, sup_id|
        stu = Student.find_by(netID: stu_id)
        sup = Supervisor.find_by(netID: sup_id)
        if stu.supervisors.find_by(netID: sup_id)
          flash[:info] = Array(flash[:info]).push('Student with netID ' + stu_id + ' already assigned.')
        else
          stu.supervisors << sup
          olddb_assign(stu.netID, sup.netID)
        end
      end

      flash[:success] = Array(flash[:success]).push('All students assigned successfully.')
      flash.delete(:assign_lists)
      redirect_to batch_assign_url
    end
  end

  def olddb_assign(stu_netID, sup_netID)
    @old_student = OldUser.first(net_id: stu_netID)
    @old_supervisor = OldUser.first(net_id: sup_netID)
    if @old_student && @old_supervisor
      if exist = OldRelation[student_net_id: @old_student.id, supervisor_net_id: @old_supervisor.id]
        exist.update(status: 1)
      else
        @old_rel = OldRelation.create(student_net_id: @old_student.id, supervisor_net_id: @old_supervisor.id, status: 1)
      end
    end
  end

  def olddb_unassign(stu_netID, sup_netID)
    @old_student = OldUser.first(net_id: stu_netID)
    @old_supervisor = OldUser.first(net_id: sup_netID)
    if @old_student && @old_supervisor
      if @old_rel = OldRelation.first(student_net_id: @old_student.id, supervisor_net_id: @old_supervisor.id)
        @old_rel.update(status: 2)
      end
    end
  end
end
