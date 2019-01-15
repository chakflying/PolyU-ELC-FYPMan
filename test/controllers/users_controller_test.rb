# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test 'should not create User with no username' do
    user = User.new
    assert_not user.save
  end
end
