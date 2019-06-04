# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper
  include SessionsHelper
  include UsersHelper
  include StudentsHelper
  include SupervisorsHelper
  include AssignHelper
  include TodosHelper
  include DepartmentsHelper
  include FacultiesHelper
  include UniversitiesHelper

  before_action :set_last_seen_at, if: proc { logged_in? && (current_user.last_seen_at.nil? || current_user.last_seen_at < 15.minutes.ago) }
  before_action :set_paper_trail_whodunnit
  before_action :session_expires
  after_action :store_location
  before_action :set_raven_context
  before_action :reset_hsts
  # before_action :show_profiler

  def render_404
    raise ActionController::RoutingError, 'Not Found'
  end

  private
  def set_raven_context
    Raven.user_context(id: session[:user_id]) # or anything else in session
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
