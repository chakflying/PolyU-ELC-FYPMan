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
  end
end