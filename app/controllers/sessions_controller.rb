# frozen_string_literal: true

class SessionsController < ApplicationController
  # SessionsController handles login and logout related actions.
  def new; end

  def create
    user = User.find_by(email: params[:session][:username].downcase)
    user ||= User.find_by(username: params[:session][:username])
    if user&.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      log_in user
      redirect_back_or '/students'
    else
      # Create an error message.
      flash[:danger] = Array(flash[:danger]).push('Invalid email/password combination.')
      redirect_to root_url
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
