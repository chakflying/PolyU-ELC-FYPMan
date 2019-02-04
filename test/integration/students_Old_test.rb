# frozen_string_literal: true

require 'test_helper'

class StudentsOldTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @user2 = users(:two)
    @student = students(:one)
    @department = Department.find(16)
    %i[users departments].each { |x| Old_DB.from(x).truncate }
  end

  test 'Normal create and delete students' do
    @old_department = OldDepartment.create(name: @department.name, short_name: @department.code, status: 1)
    @department.sync_id = @old_department.id
    @department.save!
    assert_equal @department.sync_id, OldDepartment.last.id

    login_as users(:one)
    assert is_logged_in?

    get students_path
    assert_difference 'OldUser.count', 1 do
      post students_path, params: { student: { name: 'Stupid Me', netID: 'stupid01', fyp_year: '2018-2019', department_id: 16 } }
      follow_redirect! while redirect?
    end

    @student = Student.last
    patch student_path(@student), params: { student: { name: 'Stupid You', netID: 'stupid01', fyp_year: '2018-2019', department_id: 16 } }
    assert_equal 'Stupid You', OldUser.last.common_name

    assert_difference 'OldUser.count', 0 do
      delete student_path(@student)
      follow_redirect! while redirect?
    end

    assert_equal 2, OldUser[net_id: 'stupid01'].status
  end
end
