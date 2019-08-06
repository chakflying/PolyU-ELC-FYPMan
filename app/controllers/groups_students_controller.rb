# frozen_string_literal: true

class GroupsStudentsController < ApplicationController
  before_action :authenticate_user!

  def show; end

  def create
    @groups_student = GroupsStudent.new(groups_student_params)
    
    if @groups_student.save
      render plain: 'submitted'
    else
      render plain: 'failed'
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
    if @groups_student.destroy
      render plain: 'submitted'
    else
      render plain: 'failed'
    end
  end

  private

  def groups_student_params
    params.require(:groups_student).permit(:group_id, :student_id)
  end
end
