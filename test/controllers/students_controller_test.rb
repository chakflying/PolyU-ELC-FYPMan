# frozen_string_literal: true

require 'test_helper'

class StudentsControllerTest < ActionDispatch::IntegrationTest
  test 'Visitor should not get Students Page' do
    get students_url
    follow_redirect!
    assert_select 'h1', { count: 1, text: 'Log in' }, 'Wrong title or more than one h1 element'
  end

  test 'should get index' do
    login_as users(:one)
    get students_url
    assert_select 'h2', { count: 1, text: 'Manage Students' }, 'Wrong title or more than one h2 element'
  end

  test 'should not create student with no netID' do
    student = Student.new(name: 'A', department_id: 16, fyp_year: '2018-2019')
    assert_not student.save
  end

  test 'should get edit student' do
    login_as users(:one)
    get edit_student_path(1)
    assert_select 'h2', { count: 1, text: 'Edit Student' }, 'Wrong title or more than one h2 element'
  end
end
