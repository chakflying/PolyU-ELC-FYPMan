# frozen_string_literal: true

class GroupsSupervisorsController < ApplicationController
  before_action :authenticate_user!

  def show; end

  def create
    @groups_supervisor = GroupsSupervisor.new(groups_supervisor_params)
    
    if @groups_supervisor.save
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
    if @groups_supervisor.destroy
      render plain: 'submitted'
    else
      render plain: 'failed'
    end
  end

  private

  def groups_supervisor_params
    params.require(:groups_supervisor).permit(:group_id, :supervisor_id)
  end
end
