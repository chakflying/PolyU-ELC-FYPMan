# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :authenticate_admin_404!

  # Function to show PaperTrail versions. Uses AJAX datables gem.
  def activities
    if params[:students]
      type = 'Student'
    elsif params[:supervisors]
      type = 'Supervisor'
    elsif params[:users]
      type = 'User'
    elsif params[:departments]
      type = 'Department'
    elsif params[:todos]
      type = 'Todo'
    else
      type = ''
    end
    respond_to do |format|
      format.html
      format.json { render json: PaperTrail::VersionDatatable.new(params, item_type: type) }
    end
  end

  # Function to show all users. Living here instead of the users controller for now.
  def users
    @users = User.all.includes(:department)
  end
end
