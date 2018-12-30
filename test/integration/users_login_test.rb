require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

    def setup
        @user = users(:one)
    end
    
    test "login with invalid information" do
        get root_path
        assert_select "h1", {:count=>1, :text=>"Log in"}, "Wrong title or more than one h1 element before failed login"
        post login_path, params: { session: { username: "", password: "" } }
        assert_redirected_to root_path
        follow_redirect!
        assert_select "h1", {:count=>1, :text=>"Log in"}, "Wrong title or more than one h1 element after failed login"
        assert_not flash.empty?
        get root_path
        assert flash.empty?
    end

    test "login with valid information" do
        get root_path
        post login_path, params: { session: { username:  @user.email,
                                            password: 'password' } }
        assert_redirected_to root_path
        follow_redirect!
        assert_redirected_to students_path
        follow_redirect!
        assert_select "h2", {:count=>1, :text=>"Manage Students"}, "Wrong title or more than one h2 element after logged in"
        assert_select "a[href=?]", login_path, count: 0
        assert_select "a[href=?]", logout_path
        assert_select "a[href=?]", edit_user_path(@user)
    end

    test "login then logout" do
        get root_path
        post login_path, params: { session: { username:  @user.email,
                                            password: 'password' } }
        assert_redirected_to root_path
        follow_redirect!
        assert_redirected_to students_path
        follow_redirect!
        assert is_logged_in?

        delete logout_path
        assert_not is_logged_in?
        assert_redirected_to root_url
        follow_redirect!
        assert_select "a[href=?]", logout_path,      count: 0
        assert_select "a[href=?]", user_path(@user), count: 0
    end    
end