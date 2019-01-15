# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :authenticate_admin_404!

  def activities
    @versions = if params[:students]
                  PaperTrail::Version.where(item_type: 'Student')
                elsif params[:supervisors]
                  PaperTrail::Version.where(item_type: 'Supervisor')
                elsif params[:users]
                  PaperTrail::Version.where(item_type: 'User')
                else
                  PaperTrail::Version.all
                end
  end

  def users
    @users = User.all
  end
end
