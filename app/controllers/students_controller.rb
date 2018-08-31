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
    @fyp_year_list = [
        [Time.now.year.to_s + '-' + (Time.now.year + 1).to_s, Time.now.year.to_s + '-' + (Time.now.year + 1).to_s],
        [(Time.now.year + 1).to_s + '-' + (Time.now.year + 2).to_s, (Time.now.year + 1).to_s + '-' + (Time.now.year + 2).to_s],
        [(Time.now.year + 2).to_s + '-' + (Time.now.year + 3).to_s, (Time.now.year + 2).to_s + '-' + (Time.now.year + 3).to_s],
        [(Time.now.year + 3).to_s + '-' + (Time.now.year + 4).to_s, (Time.now.year + 3).to_s + '-' + (Time.now.year + 4).to_s],
        [(Time.now.year + 4).to_s + '-' + (Time.now.year + 5).to_s, (Time.now.year + 4).to_s + '-' + (Time.now.year + 5).to_s],
        [(Time.now.year + 5).to_s + '-' + (Time.now.year + 6).to_s, (Time.now.year + 5).to_s + '-' + (Time.now.year + 6).to_s],
    ]
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

  def assign
    if is_admin?
        @students = Student.all
        @supervisors = Supervisor.all
    else
        @students = Student.where(department: current_user.department)
        @supervisors = Supervisor.where(department: current_user.department)
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
end