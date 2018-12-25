require 'test_helper'

class SupervisorsControllerTest < ActionDispatch::IntegrationTest

    test "Visitor should not get Supervisors Page" do
        get supervisors_url
        follow_redirect!
        assert_select "h1", {:count=>1, :text=>"Log in"}, "Wrong title or more than one h1 element"
    end
    
    test "should get index" do
        login_as users(:one)
        get supervisors_url
        assert_select "h2", {:count=>1, :text=>"Manage Supervisors"}, "Wrong title or more than one h2 element"
    end

    test "should not create supervisor with no netID" do
        supervisor = Supervisor.new(name: "A", department_id: 16)
        assert_not supervisor.save
    end

    test "should get edit supervisor" do
        login_as users(:one)
        get edit_supervisor_path(1)
        assert_select "h2", {:count=>1, :text=>"Edit Supervisor"}, "Wrong title or more than one h2 element"
    end

end
