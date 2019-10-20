# frozen_string_literal: true

require 'test_helper'

class SupervisorsControllerTest < ActionDispatch::IntegrationTest
  test 'Visitor should not get Supervisors Page' do
    get supervisors_url
    follow_redirect!
    assert_select 'h4', { count: 1, text: 'Log In' }, 'Wrong title or more than one h4 element'
  end

  test 'should get index' do
    login_as users(:one)
    get supervisors_url
    assert_select 'h4', { count: 1, text: 'Manage Supervisors' }, 'Wrong title or more than one h4 element'
  end

  test 'should not create supervisor with no netID' do
    login_as users(:one)
    assert_difference 'Supervisor.count', 0 do
      post supervisors_path, params: { supervisor: { name: 'John Smith', department_id: departments(:one).id } }
      follow_redirect! while redirect?
    end
    assert_select 'h4', { count: 1, text: 'Manage Supervisors' }, 'Wrong title or more than one h4 element'
    assert_equal ['Supervisor must have a netID.'], flash[:danger]
  end

  test 'should get edit supervisor' do
    login_as users(:one)
    get edit_supervisor_path(supervisors(:one))
    assert_select 'h4', { count: 1, text: 'Edit Supervisor' }, 'Wrong title or more than one h4 element'
  end

  test 'User should create and destroy supervisor' do
    login_as users(:one)
    assert_difference 'Supervisor.count', 1 do
      post supervisors_path, params: { supervisor: { name: 'Crab Walker', netID: 'crab01', department_id: departments(:one).id } }
      follow_redirect! while redirect?
    end
    assert_select 'h4', { count: 1, text: 'Manage Supervisors' }, 'Wrong title or more than one h4 element'
    assert_equal ['Supervisor successfully added!'], flash[:success]

    assert_difference 'Supervisor.count', -1 do
      delete supervisor_path(Supervisor.last.id)
      follow_redirect! while redirect?
    end
    assert_select 'h4', { count: 1, text: 'Manage Supervisors' }, 'Wrong title or more than one h4 element'
    assert_equal ['Supervisor deleted.'], flash[:success]
  end
end
