# frozen_string_literal: true

require 'test_helper'

class AssignOldTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @user2 = users(:two)
    @department = Department.find(16)
    Old_DB["SET FOREIGN_KEY_CHECKS=0;"]
    %i[users departments supervises].each { |x| Old_DB.from(x).truncate }
    Old_DB["SET FOREIGN_KEY_CHECKS=1;"]
  end

  test 'Normal assign and unassign' do
    @old_department = OldDepartment.create(name: @department.name, short_name: @department.code, status: 1)
    @department.sync_id = @old_department.id
    @department.save!
    assert_equal @department.sync_id, OldDepartment.last.id

    login_as users(:one)
    assert is_logged_in?

    get supervisors_path
    assert_difference 'OldUser.count', 1 do
      post supervisors_path, params: { supervisor: { name: 'Stupid Me', netID: 'stupid02', department_id: 16 } }
      follow_redirect! while redirect?
    end
    @supervisor = Supervisor.last
    get students_path
    assert_difference 'OldUser.count', 1 do
      post students_path, params: { student: { name: 'Stupid You', netID: 'stupid01', fyp_year: '2018-2019', department_id: 16 } }
      follow_redirect! while redirect?
    end
    @student = Student.last

    get assign_path
    assert_difference 'OldRelation.count', 1 do
      post assign_path, params: { student_netID: ['stupid01'], supervisor_netID: ['stupid02'] }
    end

    assert_difference 'OldRelation.count', 0 do
      post unassign_path, params: { student_netID: 'stupid01', supervisor_netID: 'stupid02' }
    end

    assert_equal 2, OldRelation[student_net_id: OldUser[net_id: 'stupid01'].id].status
  end
end
