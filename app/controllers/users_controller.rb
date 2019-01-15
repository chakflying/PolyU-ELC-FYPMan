# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[edit update destroy]
  before_action :correct_user!, only: %i[edit update destroy]

  def show
    @user = User.find(params[:id])
  end

  def edit
    @departments_list = get_departments_list
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = Array(flash[:success]).push('Profile updated.')
      redirect_to @user
    else
      render 'edit'
      end
  end

  def new
    @user = User.new
    @departments_list = get_departments_list
  end

  def create
    @departments_list = get_departments_list
    @user = User.new(user_params)
    if @user.save
      flash[:success] = Array(flash[:success]).push('Sign Up successful!')
      redirect_to @user
    else
      flash.now[:danger] = Array(flash.now[:danger]).push('Error when creating user.')
      render 'new'
    end
  end

  def destroy
    f = User.find(params[:id])
    name = f.username
    if f.destroy
      flash[:success] = Array(flash[:success]).push('User ' + name + ' deleted.')
    end
    redirect_back_or(admin_users_url)
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :department_id)
  end

  def correct_user!
    @user = User.find(params[:id])
    if @user != current_user && !is_admin? then render_404 end
  end
end
