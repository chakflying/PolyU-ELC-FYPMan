class SupervisorsController < ApplicationController
    before_action :authenticate_user!
    def index
        if is_admin?
            @supervisors = Supervisor.all
            @departments_list = get_departments_list
        else
            @supervisors = Supervisor.where(department: current_user.department)
        end
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

    def destroy
        Supervisor.find(params[:id]).destroy
        flash[:success] = "Supervisor deleted."
        redirect_to '/supervisors'
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

    def removeStudent
        sup_id = request.params[:sup_netID]
        stu_id = request.params[:stu_netID]
        @supervisors = Supervisor.all
        @supervisor = Supervisor.find_by(netID: sup_id)
        stu = Student.find_by(netID: stu_id)
        if !@supervisor
            flash[:danger] = "Supervisor not found"
            redirect_to '/supervisors'
        elsif !stu
            flash[:danger] = "Student not found"
            redirect_to '/supervisors'
        else
            @supervisor.students.delete(stu)
            flash[:success] = "Student unassigned successfully."
            redirect_to '/supervisors'
        end
    end
  end