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
            flash[:success] = Array(flash[:success]).push("Supervisor successfully added!")
            redirect_to '/supervisors'
        else
            if params[:department] == ""
                flash[:danger] = Array(flash[:danger]).push("Please select the supervisor's department.")
            elsif params[:name] == ""
                flash[:danger] = Array(flash[:danger]).push("Supervisor must have a name.")
            else
                flash[:danger] = Array(flash[:danger]).push("Supervisor cannot be created.")
            end
            redirect_to '/supervisors'
        end
    end
  
    def supervisor_params
        params.require(:supervisor).permit(:name, :netID, :department)
    end

    def update
        @supervisor = Supervisor.find(params[:id])
        @departments_list = get_departments_list
        @fyp_year_list = get_fyp_years_list
        if request.patch?
            if @supervisor.update_attributes(supervisor_params)
                flash[:success] = Array(flash[:success]).push("Supervisor updated.")
                redirect_to '/supervisors'
            else
                render 'update'
            end
        end
      end

    def destroy
        Supervisor.find(params[:id]).destroy
        flash[:success] = Array(flash[:success]).push("Supervisor deleted.")
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
            department = request.params[:supervisors_list][:department]
            if name_list.length < netID_list.length
                flash[:danger] = Array(flash[:danger]).push("Every supervisor must have a name.")
                redirect_back(fallback_location: supervisors_batch_import_path)
                return
            end
            if name_list.length > netID_list.length
                flash[:danger] = Array(flash[:danger]).push("Every supervisor must have a netID.")
                redirect_back(fallback_location: supervisors_batch_import_path)
                return
            end
            if department == ""
                flash[:danger] = Array(flash[:danger]).push("Please select the Department of the supervisor(s).")
                redirect_back(fallback_location: supervisors_batch_import_path)
                return
            end
            if netID_list.length == 0
                flash[:danger] = Array(flash[:danger]).push("Please enter supervisor(s) info.")
                redirect_back(fallback_location: supervisors_batch_import_path)
                return
            end
            netID_list.zip(name_list).each do |netID, name|
                # print "Supervisor " + netID.to_s + " " + name.to_s + "\n"
                @supervisor = Supervisor.new(department: department, netID: netID, name: name)  
                if !@supervisor.save
                    if name == ""
                        flash[:danger] = Array(flash[:danger]).push("Supervisor "+ netID.to_s + " must have a name.")
                    else
                        flash[:danger] = Array(flash[:danger]).push("Error when saving supervisor " + netID.to_s)
                    end
                    redirect_back(fallback_location: supervisors_batch_import_path)
                    return
                end
            end
            flash[:success] = Array(flash[:success]).push("All supervisors successfully created.")
            redirect_to '/supervisors'
        end
    end
  end