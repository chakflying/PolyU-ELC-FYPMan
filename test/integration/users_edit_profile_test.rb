require 'test_helper'

class UsersEditProfileTest < ActionDispatch::IntegrationTest

    def setup
        @user = users(:one)
    end
    
    test "non admin should not modify other profiles" do
        get root_path
        post login_path, params: { session: { username:  @user.email,
                                            password: 'password' } }
        while redirect? do
            follow_redirect!
        end
        assert is_logged_in?
        
        get edit_user_path(2)
        assert_redirected_to students_path
    end    
end