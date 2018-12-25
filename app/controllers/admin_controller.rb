class AdminController < ApplicationController
  before_action :authenticate_admin!

  def activities
    if params[:students]
      @versions = PaperTrail::Version.where(item_type: "Student")
    elsif params[:supervisors]
      @versions = PaperTrail::Version.where(item_type: "Supervisor")
    elsif params[:users]
      @versions = PaperTrail::Version.where(item_type: "User")
    else
      @versions = PaperTrail::Version.all
    end
  end

  def users
    @users = User.all
  end

end
