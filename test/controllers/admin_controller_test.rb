require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest

    test "Visitor should not get Admin Main Page" do
        get admin_url
        follow_redirect!
        assert_select "h1", {:count=>1, :text=>"Log in"}, "Wrong title or more than one h1 element"
    end

    test "Non Admin should not get Admin Main Page" do
        login_as users(:one)
        get admin_url
        follow_redirect!
        follow_redirect!
        assert_select "h2", {:count=>1, :text=>"Manage Students"}, "Wrong title or more than one h2 element"
    end

    test "should get Admin Main Page" do
        login_as users(:two)
        get admin_url
        assert_response :success
    end

    test "should get Admin Database Activity" do
        login_as users(:two)
        get admin_trails_url
        assert_select "h2", {:count=>1, :text=>"Database Activity"}, "Wrong title or more than one h2 element"
    end

    test "should get Admin Manage Users" do
        login_as users(:two)
        get admin_users_url
        assert_select "h2", {:count=>1, :text=>"Manage Users"}, "Wrong title or more than one h2 element"
    end
end
