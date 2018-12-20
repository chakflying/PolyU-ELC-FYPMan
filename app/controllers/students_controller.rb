class StudentsController < ApplicationController
  before_action :authenticate_user!
  def index
    if is_admin?
        @students = Student.all
        @departments_list = get_departments_list
    else
        @students = Student.where(department: current_user.department)
    end
    @fyp_year_list = get_fyp_years_list
    @student = Student.new
  end

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(student_params)
    if Student.find_by(netID: params[:netID])
        flash[:danger] = Array(flash[:danger]).push("Student with this netID already exist.")
        if is_admin?
            @students = Student.all
            @departments_list = get_departments_list
        else
            @students = Student.where(department: current_user.department)
        end
        @fyp_year_list = get_fyp_years_list
        render 'index'
        return
    end
    if @student.save
        sync_id = olddb_student_create(student_params)
        @student.sync_id = sync_id
        @student.save
        flash[:success] = Array(flash[:success]).push("Student successfully added!")
        redirect_to '/students'
    else
        flash[:danger] = Array(flash[:danger]).push("Error when creating student.")
        if is_admin?
            @students = Student.all
            @departments_list = get_departments_list
        else
            @students = Student.where(department: current_user.department)
        end
        @fyp_year_list = get_fyp_years_list
        render 'index'
    end
  end

  def student_params
      params.require(:student).permit(:name, :netID, :department_id, :fyp_year)
  end

  def update
    @student = Student.find(params[:id])
    @departments_list = get_departments_list
    @fyp_year_list = get_fyp_years_list
    if request.patch?
        if @student.update_attributes(student_params)
            olddb_student_update(student_params)
            flash[:success] = Array(flash[:success]).push("Student updated.")
            redirect_to '/students'
        else
            render 'update'
        end
    end
  end

  def destroy
    sync_id = Student.find(params[:id]).sync_id
    if Student.find(params[:id]).destroy
        olddb_student_destroy(sync_id)
        flash[:success] = Array(flash[:success]).push("Student deleted.")
    else
        flash[:danger] = Array(flash[:danger]).push("Error deleting student.")
    end
    redirect_to '/students'
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
    @student = Student.find_by(netID: stu_id)
    sup = Supervisor.find_by(netID: sup_id)
    if !@student
        flash[:danger] = Array(flash[:danger]).push("Student not found")
        redirect_to '/students'
    elsif !sup
        flash[:danger] = Array(flash[:danger]).push("Supervisor not found")
        redirect_to '/students'
    else
        @student.supervisors.delete(sup)
        olddb_student_removeSupervisor(stu_id, sup_id)
        flash[:success] = Array(flash[:success]).push("Supervisor removed successfully.")
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
        netID_list = request.params[:students_list][:netID_list].lines.each {|x| x.strip!}
        name_list = request.params[:students_list][:name_list].lines.each {|x| x.strip!}
        department_id = request.params[:students_list][:department_id]
        fyp_year = request.params[:students_list][:fyp_year]
        if name_list.length != netID_list.length
            flash[:danger] = Array(flash[:danger]).push("Length of NetIDs does not match length of names. Press Enter to skip line if name isn't available.")
            render 'batch_import'
            return
        end
        if name_list.length > netID_list.length
            flash[:danger] = Array(flash[:danger]).push("Every student must have a netID.")
            render 'batch_import'
            return
        end
        if fyp_year == ""
            flash[:danger] = Array(flash[:danger]).push("Please select FYP year of the student(s).")
            render 'batch_import'
            return
        end
        if department_id == ""
            flash[:danger] = Array(flash[:danger]).push("Please select the Department of the student(s).")
            render 'batch_import'
            return
        end
        if netID_list.length == 0
            flash[:danger] = Array(flash[:danger]).push("Please enter student(s) info.")
            render 'batch_import'
            return
        end
        netID_list.zip(name_list).each do |netID, name|
            if Student.find_by(netID: netID)
                flash[:danger] = Array(flash[:danger]).push("Student with netID: " + netID + " already exist.")
                render 'batch_import'
                return
            end
            @student = Student.new(department_id: department_id, fyp_year: fyp_year, netID: netID, name: name)  
            if !@student.save
                flash[:danger] = Array(flash[:danger]).push("Error when saving student " + netID.to_s)
                redirect_back(fallback_location: students_batch_import_path)
                return
            else
                sync_id = olddb_student_create({department: Department.find(department_id).name, fyp_year: fyp_year, netID: netID, name: name})
                @student.sync_id = sync_id
                @student.save
            end
        end
        flash[:success] = Array(flash[:success]).push("All students successfully created.")
        redirect_to '/students'
    end
  end

end