# frozen_string_literal: true

module ApplicationHelper
  # Reset the strict SSL headers present if force-ssl is set to true
  def reset_hsts
    response.set_header('Strict-Transport-Security', 'max-age=0; includeSubdomains;')
  end

  def show_profiler
    if current_user && is_admin?
      Rack::MiniProfiler.authorize_request
    end
  end
end
