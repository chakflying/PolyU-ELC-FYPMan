class UsersController < ApplicationController
    before_action :correct_user,   only: [:edit, :update]
    before_action :authenticate_user!,   only: [:edit, :update]

    def show
        @user = User.find(params[:id])
    end

    def admin
        if not is_admin?
            redirect_to :root
        end
        @users = User.all
    end

    def edit
        @departments_list = get_departments_list
    end

    def update
        if @user.update_attributes(user_params)
            flash[:success] = "Profile updated"
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
        @user = User.new(user_params)    # Not the final implementation!
        if @user.save
            flash[:success] = "Sign Up successful!"
            redirect_to @user
        else
            # flash[:danger] = "test"
            render 'new'
        end
    end

    def user_params
        params.require(:user).permit(:username, :email, :password, :password_confirmation, :department)
    end

    def correct_user
        @user = User.find(params[:id])
        redirect_to(root_url) unless (@user == current_user) or is_admin?
      end
  end