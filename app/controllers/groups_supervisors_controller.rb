# frozen_string_literal: true

class GroupsSupervisorsController < ApplicationController
  before_action :authenticate_user!

  def show; end

  def create
    @groups_supervisor = GroupsSupervisor.new(groups_supervisor_params)
    if @groups_supervisor.save && olddb_create_group_supervisor(groups_supervisor_params)
      render plain: 'submitted'
    else
      render plain: 'failed'
    end
  end

  def update
    @groups_supervisor = GroupsSupervisor.find_by(groups_supervisor_params)
    respond_to do |format|
      if @groups_supervisor.update(group_params)
        format.text { render text: 'submitted' }
        format.json { render :show, status: :ok, location: @groups_supervisor }
      else
        format.text { render text: 'failed' }
        format.json { render json: @groups_supervisor.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @groups_supervisor = GroupsSupervisor.find_by(groups_supervisor_params)
    if @groups_supervisor.destroy && olddb_destroy_group_supervisor(groups_supervisor_params)
      render plain: 'submitted'
    else
      render plain: 'failed'
    end
  end

  def olddb_create_group_supervisor(params)
    return if Group.find(params[:group_id]).sync_id.blank? || Supervisor.find(params[:supervisor_id]).sync_id.blank?

    @old_group_member = OldChatRoomMember[chat_room_id: Group.find(params[:group_id]).sync_id, user_id: Supervisor.find(params[:supervisor_id]).sync_id]
    if @old_group_member.present?
      @old_group_member.update(status: 1)
    else
      @old_group_member = OldChatRoomMember.create(chat_room_id: Group.find(params[:group_id]).sync_id, user_id: Supervisor.find(params[:supervisor_id]).sync_id, status: 1)
    end
  end

  def olddb_destroy_group_supervisor(params)
    return if Group.find(params[:group_id]).sync_id.blank? || Supervisor.find(params[:supervisor_id]).sync_id.blank?

    @old_group_member = OldChatRoomMember[chat_room_id: Group.find(params[:group_id]).sync_id, user_id: Supervisor.find(params[:supervisor_id]).sync_id]
    @old_group_member.update(status: 2) if @old_group_member.present?
  end

  private

  def groups_supervisor_params
    params.require(:groups_supervisor).permit(:group_id, :supervisor_id)
  end
end
