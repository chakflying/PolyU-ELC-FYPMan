# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[edit update destroy]
  before_action :correct_user!, only: %i[edit update destroy]
  before_action :authenticate_admin_404!, only: %i[new create destroy]

  def show
    @user = User.find(params[:id])
  end

  def edit
    @universities_list = get_universities_list
    @departments_list = get_departments_list(@user.university_id)
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = Array(flash[:success]).push('Profile updated.')
      redirect_to @user
    else
      @departments_list = get_departments_list
      render 'edit'
      end
  end

  def new
    @user = User.new
    @departments_list = get_departments_list
    @universities_list = get_universities_list
  end

  def create
    @departments_list = get_departments_list
    @user = User.new(user_params)
    if @user.save
      flash[:success] = Array(flash[:success]).push('New user created successfully.')
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
    redirect_back_or(users_url)
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :department_id)
  end

  def correct_user!
    @user = User.find(params[:id])
    render_404 if @user != current_user && !is_admin?
  end
end
