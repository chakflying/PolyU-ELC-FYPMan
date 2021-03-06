# frozen_string_literal: true

class AdminController < ApplicationController
  # AdminController handles various pages to display information for the site admin.
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

  # Display Sync Records that are produced after each sync ran.
  def sync_records
    respond_to do |format|
      format.html
      format.json { render json: SyncRecordDatatable.new(params) }
    end
  end

  # Button in the Sync Records page.
  def sync_records_delete_older_than
    num = SyncRecord.where("created_at < ?", params[:days].to_i.days.ago).delete_all
    flash[:info] = Array(flash[:info]).push("#{num} records deleted.")
    redirect_to sync_records_url
  end

  # Function to show all users. Living here instead of the users controller for now.
  def users
    @users = User.all.includes(:department)
  end
end
