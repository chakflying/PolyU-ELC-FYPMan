# frozen_string_literal: true

class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    if is_admin?
      @students = Student.all.select(:id, :netID, :name).to_a
    else
      @students = Student.where(department: current_user.department).select(:id, :netID, :name).to_a
    end
    @group = Group.new
    respond_to do |format|
      format.html
      format.json { render json: GroupDatatable.new(params, admin: is_admin?, current_user_department: current_user.department.id) }
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)

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
    respond_to do |format|
      if @group.update(group_params)
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
    @group.destroy
    respond_to do |format|
      format.text { render plain: "submitted" }
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def create_group_and_add
    puts params
    @group = Group.new(group_params)
    if @group.save
      params[:student_ids].each do |stu_id|
        if Student.find(stu_id).present?
          GroupsStudent.create(group_id: @group.id, student_id: stu_id)
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
