# frozen_string_literal: true

class GroupsStudentsController < ApplicationController
  before_action :authenticate_user!

  def show; end

  def create
    if GroupsStudent.find_by(groups_student_params)
      render plain: 'submitted'
    else
      @groups_student = GroupsStudent.new(groups_student_params)
      if @groups_student.save && olddb_create_group_student(groups_student_params)
        render plain: 'submitted'
      else
        render plain: 'failed'
      end
    end
  end

  def update
    @groups_student = GroupsStudent.find_by(groups_student_params)
    respond_to do |format|
      if @groups_student.update(group_params)
        format.text { render text: 'submitted' }
        format.json { render :show, status: :ok, location: @groups_student }
      else
        format.text { render text: 'failed' }
        format.json { render json: @groups_student.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @groups_student = GroupsStudent.find_by(groups_student_params)
    if @groups_student.destroy && olddb_destroy_group_student(groups_student_params)
      render plain: 'submitted'
    else
      render plain: 'failed'
    end
  end

  def olddb_create_group_student(params)
    return if Group.find(params[:group_id]).sync_id.blank? || Student.find(params[:student_id]).sync_id.blank?

    @old_group_member = OldChatRoomMember[chat_room_id: Group.find(params[:group_id]).sync_id, user_id: Student.find(params[:student_id]).sync_id]
    if @old_group_member.present?
      @old_group_member.update(status: 1)
    else
      @old_group_member = OldChatRoomMember.create(chat_room_id: Group.find(params[:group_id]).sync_id, user_id: Student.find(params[:student_id]).sync_id, status: 1)
    end
  end

  def olddb_destroy_group_student(params)
    return if Group.find(params[:group_id]).sync_id.blank? || Student.find(params[:student_id]).sync_id.blank?

    @old_group_member = OldChatRoomMember[chat_room_id: Group.find(params[:group_id]).sync_id, user_id: Student.find(params[:student_id]).sync_id]
    @old_group_member.update(status: 2) if @old_group_member.present?
  end

  private

  def groups_student_params
    params.require(:groups_student).permit(:group_id, :student_id)
  end
end
