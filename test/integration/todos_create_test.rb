require 'test_helper'

class TodosCreateTest < ActionDispatch::IntegrationTest

    def setup
        @user = users(:one)
        @user2 = users(:two)
        @todo = todos(:two)
    end
    
    test "non admin create todos" do
        get root_path
        post login_path, params: { session: { username:  @user.email,
                                            password: 'password' } }
        while redirect? do
            follow_redirect!
        end
        assert is_logged_in?
        
        get todos_path
        assert_difference 'Todo.count', 1 do
            post todos_path, params: { todo: { title: @todo.title, description: @todo.description, eta: @todo.eta, department_id: @todo.department_id } }
    
            while redirect? do
                follow_redirect!
            end
        end
    end

    test "non admin attempt to create global todos" do
        get root_path
        post login_path, params: { session: { username:  @user.email,
                                            password: 'password' } }
        while redirect? do
            follow_redirect!
        end
        assert is_logged_in?
        
        get todos_path
        assert_difference 'Todo.count', 1 do
            post todos_path, params: { todo: { title: @todo.title, description: @todo.description, eta: @todo.eta, department_id: "" } }
    
            while redirect? do
                follow_redirect!
            end
        end
        assert_equal @user.department.id, Todo.last.department.id
    end

    test "admin create global todos" do
        get root_path
        post login_path, params: { session: { username:  @user2.email,
                                            password: 'password' } }
        while redirect? do
            follow_redirect!
        end
        assert is_logged_in?
        
        get todos_path
        assert_difference 'Todo.count', 1 do
            post todos_path, params: { todo: { title: @todo.title, description: @todo.description, eta: @todo.eta, department_id: "" } }
    
            while redirect? do
                follow_redirect!
            end
        end
        assert_nil Todo.last.department
    end    
end