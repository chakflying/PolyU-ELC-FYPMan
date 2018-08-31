class UsersController < ApplicationController

    def show
        @user = User.find(params[:id])
    end

    def admin
        if not is_admin?
            redirect_to :root
        end
        @users = User.all
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

  end