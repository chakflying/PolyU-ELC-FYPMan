class StudentsController < ApplicationController
  before_action :authenticate_user!
  def index
    if is_admin?
        @students = Student.all
        @departments_list = get_departments_list
    else
        @students = Student.where(department: current_user.department)
    end
    @student = Student.new
    @fyp_year_list = get_fyp_years_list
  end

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(student_params)  # Not the final implementation!
    if @student.save
        flash[:success] = "Student successfully added!"
        redirect_to '/students'
    else
        # flash[:danger] = "test"
        @students = Student.all
        render 'index'
    end
  end

  def student_params
      params.require(:student).permit(:name, :netID, :department, :fyp_year)
  end

  def update
    @student = Student.find(params[:id])
    @departments_list = get_departments_list
    @fyp_year_list = get_fyp_years_list
    if request.patch?
        if @student.update_attributes(student_params)
            flash[:success] = "Student updated."
            redirect_to '/students'
        else
            render 'update'
        end
    end
  end

  def destroy
    Student.find(params[:id]).destroy
    flash[:success] = "Student deleted."
    redirect_to '/students'
  end

  def assign
    if is_admin?
        @students = Student.all.select(:netID, :name).to_a
        @supervisors = Supervisor.all.select(:netID, :name).to_a
    else
        @students = Student.where(department: current_user.department).select(:netID, :name).to_a
        @supervisors = Supervisor.where(department: current_user.department).select(:netID, :name).to_a
    end
    if request.post?
        stu_ids = request.params[:student_netID].values
        sup_id = (request.params[:supervisor_netID].values)[0].to_s
        sup = Supervisor.find_by(netID: sup_id)
        if !sup
            flash[:danger] = "Supervisor with netID " + sup_id + " not found."
            render plain: "submitted"
            return
        end
        stu_ids.each do |stu_id|
            stu = Student.find_by(netID: stu_id)
            if !stu
                flash[:danger] = "Student with netID " + stu_id + " not found."
            else
                stu.supervisors << sup
                flash[:success] = "Student with netID " + stu_id + " assigned successfully."
            end
        end
        render plain: "submitted"
    end
  end

  def getStudentName
    if request.post?
        stu_id = request.params[:netID]
        stu = Student.find_by(netID: stu_id)
        if !stu
            render plain: "Student not found"
        else
            render plain: stu.name
        end
    end
  end

  def removeSupervisor
    sup_id = request.params[:sup_netID]
    stu_id = request.params[:stu_netID]
    @students = Student.all
    @student = Student.find_by(netID: stu_id)
    sup = Supervisor.find_by(netID: sup_id)
    if !@student
        flash[:danger] = "Student not found"
        redirect_to '/students'
    elsif !sup
        flash[:danger] = "Supervisor not found"
        redirect_to '/students'
    else
        @student.supervisors.delete(sup)
        flash[:success] = "Supervisor removed successfully."
        redirect_to '/students'
    end
  end

  def batch_import
    @student = Student.new
    @fyp_year_list = get_fyp_years_list
    if is_admin?
        @departments_list = get_departments_list
    end

    if request.post?
        netID_list = request.params[:student_list][:netID_list].lines.each {|x| x.strip!}
        name_list = request.params[:student_list][:name_list].lines.each {|x| x.strip!}
        department = request.params[:student_list][:department]
        fyp_year = request.params[:student_list][:fyp_year]
        if name_list.length != netID_list.length
            flash[:danger] = "Length of NetIDs does not match length of names. Press Enter to skip line if name isn't available."
            redirect_back(fallback_location: batch_import_path)
        end
        if name_list.length > netID_list.length
            flash[:danger] = "Every student must have a netID."
            redirect_back(fallback_location: batch_import_path)
        end
        netID_list.zip(name_list).each do |netID, name|
            print "Student " + netID.to_s + " " + name.to_s + "\n"
            @student = Student.new(department: department, fyp_year: fyp_year, netID: netID, name: name)  
            if !@student.save
                flash[:danger] = "Error when saving student " + netID.to_s
                redirect_back(fallback_location: batch_import_path)
            end
        end
        flash[:success] = "All students successfully created."
        redirect_to '/students'
    end
  end

end