require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest

    test "Visitor should not get Admin Main Page" do
        assert_raise(ActionController::RoutingError) { get trails_url }
    end

    test "Non Admin should not get Admin Main Page" do
        login_as users(:one)
        assert_raise(ActionController::RoutingError) { get trails_url }
    end

    test "should get Admin Main Page" do
        login_as users(:two)
        get trails_url
        assert_response :success
    end

    test "should get Admin Database Activity" do
        login_as users(:two)
        get trails_url
        assert_select "h2", {:count=>1, :text=>"Database Activity"}, "Wrong title or more than one h2 element"
    end

    test "should get Admin Manage Users" do
        login_as users(:two)
        get users_url
        assert_select "h2", {:count=>1, :text=>"Manage Users"}, "Wrong title or more than one h2 element"
    end
end
