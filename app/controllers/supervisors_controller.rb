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

    def getSupervisorName
        if request.post?
            sup_id = request.params[:netID]
            sup = Supervisor.find_by(netID: sup_id)
            if !sup
                render plain: "Supervisor not found"
            else
                render plain: sup.name
            end
        end
    end
  end