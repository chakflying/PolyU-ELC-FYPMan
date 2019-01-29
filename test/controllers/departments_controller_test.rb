# frozen_string_literal: true

require 'test_helper'

class DepartmentsControllerTest < ActionDispatch::IntegrationTest
  test 'Visitor should not get Departments Page' do
    assert_raise(ActionController::RoutingError) { get departments_url }

  end

  test 'Non admin should not get Departments Page' do
    login_as users(:one)
    assert_raise(ActionController::RoutingError) { get departments_url }
  end

  test 'Admin should get Departments Index' do
    login_as users(:two)
    get departments_url
    assert_select 'h2', { count: 1, text: 'Manage Departments' }, 'Wrong title or more than one h2 element'
  end

  test 'Admin should not create Department with no name' do
    login_as users(:two)
    assert_difference 'Department.count', 0 do
      post departments_path, params: { department: { name: "", code: "DOJ", faculty_id: faculties(:one).id } }
      follow_redirect! while redirect?
    end
  end

  test 'Admin should get edit department' do
    login_as users(:two)
    get edit_department_path(departments(:one).id)
    assert_select 'h2', { count: 1, text: 'Edit Department' }, 'Wrong title or more than one h2 element'
  end

  test 'Admin should create and destroy department' do
    login_as users(:two)
    assert_difference 'Department.count', 1 do
      post departments_path, params: { department: { name: "Department of Justice", code: "DOJ", faculty_id: faculties(:one).id } }
      follow_redirect! while redirect?
    end
    assert_difference 'Department.count', -1 do
      delete department_path(Department.last.id)
      follow_redirect! while redirect?
    end
  end
end
