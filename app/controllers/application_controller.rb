class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    include ApplicationHelper
    include SessionsHelper
    include UsersHelper
    include StudentsHelper
    include SupervisorsHelper
    include OldDbHelper
    include AssignHelper
    include TodosHelper

    before_action :set_last_seen_at, if: proc { logged_in? && (current_user.last_seen_at.nil? || current_user.last_seen_at < 15.minutes.ago) }
    before_action :reset_hsts
    before_action :set_paper_trail_whodunnit

    def acmeauth 
        file = Pathname.new(Dir.pwd).join('.acme-challenges').join(params[:file])
        render plain: File.read(file) and return if File.exist?(file)
        render plain: ""
        render nothing: true
        return
    end

end
