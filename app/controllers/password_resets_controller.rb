# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  before_action :get_user,   only: %i[edit update]
  before_action :valid_user, only: %i[edit update]
  before_action :check_expiration, only: %i[edit update]

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      if @user.reset_sent_at && @user.reset_sent_at > 5.minutes.ago
        flash[:danger] = Array(flash[:danger]).push('You can only send a password reset email every 5 minutes.')
        redirect_to root_url
        return
      end
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = Array(flash[:info]).push('If this user is present, an email will be sent with password reset instructions.')
      redirect_to root_url
    else
      flash[:info] = Array(flash[:info]).push('If this user is present, an email will be sent with password reset instructions.')
      redirect_to root_url
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?                  # Case (3)
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update(user_params)          # Case (4)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = Array(flash[:success]).push('Password has been reset.')
      redirect_to @user
    else
      render 'edit'                                     # Case (2)
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    redirect_to root_url unless @user&.authenticated?(:reset, params[:id])
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = Array(flash[:danger]).push('Password reset has expired.')
      redirect_to new_password_reset_url
    end
  end
end
