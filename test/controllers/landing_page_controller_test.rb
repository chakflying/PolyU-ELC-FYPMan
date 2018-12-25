require 'test_helper'

class LandingPageControllerTest < ActionDispatch::IntegrationTest
    test "should get index" do
        get root_url
        assert_response :success
    end
end
