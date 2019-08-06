# frozen_string_literal: true

require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'guest should not get sign up' do
    assert_raise(ActionController::RoutingError) { get signup_url }
  end

  test 'admin get create account' do
    login_as users(:two)
    assert is_logged_in?
    assert is_admin?

    assert_difference 'User.count', 1 do
      post users_path, params: { user: { username: 'ExampleUser',
                                         email: 'user@example.com',
                                         password: 'password',
                                         password_confirmation: 'password',
                                         department_id: 16 } }
    end
    follow_redirect!
    assert_select 'h4', { count: 1, text: 'User Profile' }, 'Wrong title or more than one h4 element after Signed up'
    assert_not flash.empty?
  end
end
