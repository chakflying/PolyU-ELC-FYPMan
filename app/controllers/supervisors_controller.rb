class SupervisorsController < ApplicationController
    before_action :authenticate_user!
    def index
      @supervisors = Supervisor.all
      @supervisor = Supervisor.new
    end
  
    def new
      @supervisor = Supervisor.new
    end
  
    def create
        @supervisor = Supervisor.new(supervisor_params)    # Not the final implementation!
        if @supervisor.save
            flash[:success] = "supervisor successfully added!"
            redirect_to '/supervisors'
        else
            # flash[:danger] = "test"
            render 'index'
        end
    end
  
    def supervisor_params
        params.require(:supervisor).permit(:name, :netID, :department)
    end
  end