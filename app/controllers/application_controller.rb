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

  before_action :set_last_seen_at, if: proc { logged_in? && (current_user.last_seen_at.nil? || current_user.last_seen_at < 15.minutes.ago) }
  before_action :set_paper_trail_whodunnit
  after_action :store_location
  before_action :show_profiler

  def render_404
    raise ActionController::RoutingError, 'Not Found'
  end
end
