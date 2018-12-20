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
        @supervisor = Supervisor.new(supervisor_params)
        if @supervisor.save
            sync_id = olddb_supervisor_create(supervisor_params)
            @supervisor.sync_id = sync_id
            @supervisor.save
            flash[:success] = Array(flash[:success]).push("Supervisor successfully added!")
            redirect_to '/supervisors'
        else
            if params[:department_id] == ""
                flash[:danger] = Array(flash[:danger]).push("Please select the supervisor's department.")
            elsif params[:name] == ""
                flash[:danger] = Array(flash[:danger]).push("Supervisor must have a name.")
            else
                flash[:danger] = Array(flash[:danger]).push("Supervisor cannot be created.")
            end
            if is_admin?
                @supervisors = Supervisor.all
                @departments_list = get_departments_list
            else
                @supervisors = Supervisor.where(department: current_user.department)
            end
            render 'index'
        end
    end
  
    def supervisor_params
        params.require(:supervisor).permit(:name, :netID, :department_id)
    end

    def update
        @supervisor = Supervisor.find(params[:id])
        @departments_list = get_departments_list
        @fyp_year_list = get_fyp_years_list
        if request.patch?
            if @supervisor.update_attributes(supervisor_params)
                olddb_supervisor_update(supervisor_params)
                flash[:success] = Array(flash[:success]).push("Supervisor updated.")
                redirect_to '/supervisors'
            else
                render 'update'
            end
        end
      end

    def destroy
        sync_id = Supervisor.find(params[:id]).sync_id
        if Supervisor.find(params[:id]).destroy
            olddb_supervisor_destroy(sync_id)
            flash[:success] = Array(flash[:success]).push("Supervisor deleted.")
        else
            flash[:danger] = Array(flash[:danger]).push("Error deleting supervisor.")
        end
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
            flash[:danger] = Array(flash[:danger]).push("Supervisor not found.")
            redirect_to '/supervisors'
        elsif !stu
            flash[:danger] = Array(flash[:danger]).push("Student not found.")
            redirect_to '/supervisors'
        else
            @supervisor.students.delete(stu)
            olddb_supervisor_removeStudent(stu_id, sup_id)
            flash[:success] = Array(flash[:success]).push("Student unassigned successfully.")
            redirect_to '/supervisors'
        end
    end

    def batch_import
        @supervisor = Supervisor.new
        if is_admin?
            @departments_list = get_departments_list
        end
    
        if request.post?
            netID_list = request.params[:supervisors_list][:netID_list].lines.each {|x| x.strip!}
            name_list = request.params[:supervisors_list][:name_list].lines.each {|x| x.strip!}
            department_id = request.params[:supervisors_list][:department_id]
            if name_list.length < netID_list.length
                flash[:danger] = Array(flash[:danger]).push("Every supervisor must have a name.")
                render 'batch_import'
                return
            end
            if name_list.length > netID_list.length
                flash[:danger] = Array(flash[:danger]).push("Every supervisor must have a netID.")
                render 'batch_import'
                return
            end
            if department_id == ""
                flash[:danger] = Array(flash[:danger]).push("Please select the Department of the supervisor(s).")
                render 'batch_import'
                return
            end
            if netID_list.length == 0
                flash[:danger] = Array(flash[:danger]).push("Please enter supervisor(s) info.")
                render 'batch_import'
                return
            end
            netID_list.zip(name_list).each do |netID, name|
                if Supervisor.find_by(netID: netID)
                    flash[:danger] = Array(flash[:danger]).push("Supervisor with netID: " + netID + " already exist.")
                    render 'batch_import'
                    return
                end
                @supervisor = Supervisor.new(department_id: department_id, netID: netID, name: name)  
                if !@supervisor.save
                    if name == ""
                        flash[:danger] = Array(flash[:danger]).push("Supervisor "+ netID.to_s + " must have a name.")
                    else
                        flash[:danger] = Array(flash[:danger]).push("Error when saving supervisor " + netID.to_s)
                    end
                    redirect_back(fallback_location: supervisors_batch_import_path)
                    return
                else
                    sync_id = olddb_supervisor_create({department: Department.find(department_id).name, netID: netID, name: name})
                    @supervisor.sync_id = sync_id
                    @supervisor.save
                end
            end
            flash[:success] = Array(flash[:success]).push("All supervisors successfully created.")
            redirect_to '/supervisors'
        end
    end
  end