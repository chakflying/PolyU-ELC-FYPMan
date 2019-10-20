# frozen_string_literal: true

require 'test_helper'

class UsersEditProfileTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test 'non admin should not modify other profiles' do
    get root_path
    login_as users(:one)
    assert is_logged_in?

    assert_raise(ActionController::RoutingError) { get edit_user_path(users(:two).id) }
  end
end
