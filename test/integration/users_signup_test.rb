require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
    test "valid signup information" do
        get signup_path
        assert_difference 'User.count', 1 do
        post users_path, params: { user: { username:  "ExampleUser",
                                            email: "user@example.com",
                                            password:              "password",
                                            password_confirmation: "password",
                                            department_id: 16 } }
        end
        follow_redirect!
        assert_select "h2", {:count=>1, :text=>"User Profile"}, "Wrong title or more than one h2 element after Signed up"
        assert_not is_logged_in?
        assert_not flash.empty?
    end
end