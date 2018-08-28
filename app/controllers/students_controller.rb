class StudentsController < ApplicationController
  before_action :authenticate_user!
  def index
    @students = Student.all
    @student = Student.new
  end

  def new
    @student = Student.new
  end

  def create
      @student = Student.new(student_params)    # Not the final implementation!
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
      params.require(:student).permit(:name, :netID, :department)
  end

  def assign
    @student = Student.new
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
end