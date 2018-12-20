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
    @student = Student.new(student_params)
    if Student.find_by(netID: params[:netID])
        flash[:danger] = Array(flash[:danger]).push("Student with this netID already exist.")
        redirect_to '/students'
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
        department = request.params[:students_list][:department]
        fyp_year = request.params[:students_list][:fyp_year]
        if name_list.length != netID_list.length
            flash[:danger] = Array(flash[:danger]).push("Length of NetIDs does not match length of names. Press Enter to skip line if name isn't available.")
            redirect_back(fallback_location: students_batch_import_path)
            return
        end
        if name_list.length > netID_list.length
            flash[:danger] = Array(flash[:danger]).push("Every student must have a netID.")
            redirect_back(fallback_location: students_batch_import_path)
            return
        end
        if fyp_year == ""
            flash[:danger] = Array(flash[:danger]).push("Please select FYP year of the student(s).")
            redirect_back(fallback_location: students_batch_import_path)
            return
        end
        if department == ""
            flash[:danger] = Array(flash[:danger]).push("Please select the Department of the student(s).")
            redirect_back(fallback_location: students_batch_import_path)
            return
        end
        if netID_list.length == 0
            flash[:danger] = Array(flash[:danger]).push("Please enter student(s) info.")
            redirect_back(fallback_location: students_batch_import_path)
            return
        end
        netID_list.zip(name_list).each do |netID, name|
            # print "Student " + netID.to_s + " " + name.to_s + "\n"
            @student = Student.new(department: department, fyp_year: fyp_year, netID: netID, name: name)  
            if !@student.save
                flash[:danger] = Array(flash[:danger]).push("Error when saving student " + netID.to_s)
                redirect_back(fallback_location: students_batch_import_path)
                return
            else
                sync_id = olddb_student_create({department: department, fyp_year: fyp_year, netID: netID, name: name})
                @student.sync_id = sync_id
                @student.save
            end
        end
        flash[:success] = Array(flash[:success]).push("All students successfully created.")
        redirect_to '/students'
    end
  end

end