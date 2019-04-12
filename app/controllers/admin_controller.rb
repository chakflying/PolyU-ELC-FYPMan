# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :authenticate_admin_404!

  # Function to show PaperTrail versions. Uses AJAX datables gem.
  def activities
    type = if params[:students]
             'Student'
           elsif params[:supervisors]
             'Supervisor'
           elsif params[:users]
             'User'
           elsif params[:departments]
             'Department'
           elsif params[:todos]
             'Todo'
           else
             ''
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

  def webconsole; end
end
