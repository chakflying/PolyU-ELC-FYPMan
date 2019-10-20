# frozen_string_literal: true

require 'test_helper'

class StudentsControllerTest < ActionDispatch::IntegrationTest
  test 'Visitor should not get Students Page' do
    get students_url
    follow_redirect!
    assert_select 'h4', { count: 1, text: 'Log In' }, 'Wrong title or more than one h4 element'
  end

  test 'should get index' do
    login_as users(:one)
    get students_url
    assert_select 'h4', { count: 1, text: 'Manage Students' }, 'Wrong title or more than one h4 element'
  end

  test 'should not create student with no netID' do
    login_as users(:one)
    assert_difference 'Student.count', 0 do
      post students_path, params: { student: { name: 'John Smith', department_id: departments(:one).id, fyp_year: '2018-2019' } }
      follow_redirect! while redirect?
    end
    assert_select 'h4', { count: 1, text: 'Manage Students' }, 'Wrong title or more than one h4 element'
    assert_equal ['Student must have a netID.'], flash[:danger]
  end

  test 'should not create student with no FYPYear' do
    login_as users(:one)
    assert_difference 'Student.count', 0 do
      post students_path, params: { student: { name: 'John Smith', netID: 'johnsmith01', department_id: departments(:one).id } }
      follow_redirect! while redirect?
    end
    assert_select 'h4', { count: 1, text: 'Manage Students' }, 'Wrong title or more than one h4 element'
    assert_equal ['Student must have an FYP Year.'], flash[:danger]
  end

  test 'should get edit student' do
    login_as users(:one)
    get edit_student_path(students(:one))
    assert_select 'h4', { count: 1, text: 'Edit Student' }, 'Wrong title or more than one h4 element'
  end

  test 'User should create and destroy student' do
    login_as users(:one)
    assert_difference 'Student.count', 1 do
      post students_path, params: { student: { name: 'Crab Walker', netID: 'crab01', fyp_year: '2018-2019', department_id: departments(:one).id } }
      follow_redirect! while redirect?
    end
    assert_select 'h4', { count: 1, text: 'Manage Students' }, 'Wrong title or more than one h4 element'
    assert_equal ['Student successfully added!'], flash[:success]

    assert_difference 'Student.count', -1 do
      delete student_path(Student.last.id)
      follow_redirect! while redirect?
    end
    assert_select 'h4', { count: 1, text: 'Manage Students' }, 'Wrong title or more than one h4 element'
    assert_equal ['Student deleted.'], flash[:success]
  end
end
