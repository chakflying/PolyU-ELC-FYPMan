# frozen_string_literal: true

module ApplicationHelper
  def reset_hsts
    response.set_header('Strict-Transport-Security', 'max-age=0; includeSubdomains;')
  end

  def show_profiler
    if current_user && is_admin?
      Rack::MiniProfiler.authorize_request
    end
  end
end
