# frozen_string_literal: true

require 'test_helper'

class DepartmentOldTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @user2 = users(:two)
    @uni = universities(:one)
    %i[users departments faculties universities].each { |x| Old_DB.from(x).truncate }
    OldDb.sync
  end

  test 'Normal create department' do
    login_as users(:two)
    assert is_logged_in?
    assert is_admin?

    get departments_path
    assert_difference 'OldDepartment.count', 1 do
      post departments_path, params: { department: { name: 'Department of Justice', code: 'DOJ', faculty_id: Faculty.first.id } }
      follow_redirect! while redirect?
    end

    assert_equal OldDepartment.last.id, Department.last.sync_id
  end

  test 'Normal create and update department' do
    login_as users(:two)
    assert is_logged_in?
    assert is_admin?
    
    post departments_path, params: { department: { name: 'Department of Justice', code: 'DOJ', faculty_id: Faculty.first.id } }
    follow_redirect! while redirect?
    assert_equal OldDepartment.last.id, Department.last.sync_id
    
    assert_difference 'OldDepartment.count', 0 do
      patch department_path(Department.last.id), params: { department: { name: 'Department of Justice', code: 'DOJ', faculty_id: Faculty.second.id, sync_id: Department.last.sync_id } }
      follow_redirect! while redirect?
    end

    assert_equal Faculty.second.sync_id, OldDepartment[Department.last.sync_id].faculty
  end

  test 'Normal create and destroy department' do
    login_as users(:two)
    assert is_logged_in?
    assert is_admin?
    
    post departments_path, params: { department: { name: 'Department of Justice', code: 'DOJ', faculty_id: Faculty.first.id } }
    follow_redirect! while redirect?

    assert_difference 'OldDepartment.count', 0 do
      delete department_path(Department.last.id)
      follow_redirect! while redirect?
    end

    assert_equal 2, OldDepartment.last.status
  end
end
