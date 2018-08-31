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
        @department_list = [
            ["Department of Applied Biology and Chemical Technology","Department of Applied Biology and Chemical Technology"],
            ["Department of Applied Mathematics","Department of Applied Mathematics"],
            ["Department of Applied Physics","Department of Applied Physics"],
            ["Institute of Textiles and Clothing","Institute of Textiles and Clothing"],
            ["School of Accounting and Finance","School of Accounting and Finance"],
            ["Department of Logistics and Maritime Studies","Department of Logistics and Maritime Studies"],
            ["Department of Management and Marketing","Department of Management and Marketing"],
            ["Department of Building and Real Estate","Department of Building and Real Estate"],
            ["Department of Building Services Engineering","Department of Building Services Engineering"],
            ["Department of Civil and Environmental Engineering","Department of Civil and Environmental Engineering"],
            ["Department of Land Surveying and Geo-Informatics","Department of Land Surveying and Geo-Informatics"],
            ["Department of Biomedical Engineering","Department of Biomedical Engineering"],
            ["Department of Computing","Department of Computing"],
            ["Department of Electrical Engineering","Department of Electrical Engineering"],
            ["Department of Electronic and Information Engineering","Department of Electronic and Information Engineering"],
            ["Department of Industrial and Systems Engineering","Department of Industrial and Systems Engineering"],
            ["Department of Mechanical Engineering","Department of Mechanical Engineering"],
            ["Interdisciplinary Division of Aeronautical and Aviation Engineering","Interdisciplinary Division of Aeronautical and Aviation Engineering"],
            ["Department of Applied Social Sciences","Department of Applied Social Sciences"],
            ["Department of Health Technology and Informatics","Department of Health Technology and Informatics"],
            ["Department of Rehabilitation Sciences","Department of Rehabilitation Sciences"],
            ["School of Nursing","School of Nursing"],
            ["School of Optometry","School of Optometry"],
            ["Department of Chinese and Bilingual Studies","Department of Chinese and Bilingual Studies"],
            ["Department of Chinese Culture","Department of Chinese Culture"],
            ["Department of English","Department of English"],
            ["Confucius Institute of Hong Kong","Confucius Institute of Hong Kong"],
            ["English Language Centre","English Language Centre"],
            ["General Education Centre","General Education Centre"],
            ["School of Design","School of Design"],
            ["School of Hotel and Tourism Management","School of Hotel and Tourism Management"]
        ]
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