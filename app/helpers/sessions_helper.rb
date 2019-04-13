# frozen_string_literal: true

module SessionsHelper
  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Get current logged in user.
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    session.delete(:expires_at)
    @current_user = nil
  end

  # Redirect to root if not admin
  def authenticate_admin!
    redirect_to :root if current_user.nil? || !current_user.admin
  end

  # Return 404 if not admin
  def authenticate_admin_404!
    render_404 if current_user.nil? || !current_user.admin
  end

  # Redirect to root if not logged in
  def authenticate_user!
    redirect_to :root if current_user.nil?
  end

  # Return 404 if not logged in
  def authenticate_user_404!
    render_404 if current_user.nil?
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def session_expires
    if session[:expires_at] && session[:expires_at].to_time < Time.now
      log_out
      redirect_to :root
    end
    if logged_in?
      session[:expires_at] = Rails.application.config.session_expires_after.from_now
    end
  end
end
