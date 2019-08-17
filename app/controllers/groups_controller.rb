# frozen_string_literal: true

class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: %i[show edit update destroy]

  # GET /groups
  # GET /groups.json
  def index
    if is_admin?
      @students = Student.all.select(:id, :netID, :name).to_a
      @supervisors = Supervisor.all.select(:id, :netID, :name).to_a
    else
      @students = Student.where(department: current_user.department).select(:id, :netID, :name).to_a
      @supervisors = Supervisor.where(department: current_user.department).select(:id, :netID, :name).to_a
    end
    @group = Group.new
    respond_to do |format|
      format.html
      format.json { render json: GroupDatatable.new(params, admin: is_admin?, current_user_department: current_user.department.id) }
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show; end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit; end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    if @group.save
      sync_id = olddb_group_create(group_params)
      @group.sync_id = sync_id
    end

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    success = false
    if @group.update_attributes(group_params)
      @group.sync_id.present? ? olddb_group_update(group_params) : false
      success = true
    end
    respond_to do |format|
      if success
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    sync_id = @group.sync_id
    if @group.destroy
      sync_id ? olddb_group_destroy(sync_id) : false
    end

    respond_to do |format|
      format.text { render plain: 'submitted' }
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def create_group_and_add
    @group = Group.new(group_params)
    if @group.save
      sync_id = olddb_group_create(group_params)
      @group.update(sync_id: sync_id)
      params[:student_ids].each do |stu_id|
        if Student.find(stu_id).present?
          GroupsStudent.create(group_id: @group.id, student_id: stu_id)
          sync_id.present? && Student.find(stu_id).sync_id.present? ? olddb_group_add_member(chat_room_id: sync_id, user_id: Student.find(stu_id).sync_id) : false
        else
          render plain: 'failed'
          return
        end
      end
      params[:supervisor_ids].each do |sup_id|
        if Supervisor.find(sup_id).present?
          GroupsSupervisor.create(group_id: @group.id, supervisor_id: sup_id)
          sync_id.present? && Supervisor.find(sup_id).sync_id.present? ? olddb_group_add_member(chat_room_id: sync_id, user_id: Supervisor.find(sup_id).sync_id) : false
        else
          render plain: 'failed'
          return
        end
      end
      render plain: 'submitted'
    else
      render plain: 'failed'
    end
  end

  def olddb_group_create(params)
    @old_group = OldChatRoom.create(status: 1, room_type: "group")
    @old_group.id
  end

  def olddb_group_update(params)
    @old_group = OldChatRoom[params[:id]]
    return if @old_group.blank?

    @old_group.update(status: (params[:status].present? ? params[:status] : 1))
  end

  def olddb_group_destroy(sync_id)
    @old_group = OldChatRoom[sync_id]
    return if @old_group.blank?

    @old_group.update(status: 2)
  end

  def olddb_group_add_member(chat_room_id:, user_id:)
    @old_group_member = OldChatRoomMember[chat_room_id: chat_room_id, user_id: user_id]
    if @old_group_member.present?
      @old_group_member.update(status: 1)
    else
      @old_group_member = OldChatRoomMember.create(status: 1, chat_room_id: chat_room_id, user_id: user_id)
    end
  end

  def olddb_group_remove_member(chat_room_id:, user_id:)
    @old_group_member = OldChatRoomMember[chat_room_id: chat_room_id, user_id: user_id]
    if @old_group_member.present?
      @old_group_member.update(status: 2)
    end    
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def group_params
    params.require(:group).permit(:type, :sync_id, :number)
  end
end
