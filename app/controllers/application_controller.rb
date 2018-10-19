class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    include ApplicationHelper
    include SessionsHelper
    include UsersHelper
    include StudentsHelper

    before_action :set_last_seen_at, if: proc { logged_in? && (current_user.last_seen_at.nil? || current_user.last_seen_at < 15.minutes.ago) }
    before_action :reset_hsts
end
