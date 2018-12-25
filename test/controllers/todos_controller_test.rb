require 'test_helper'

class TodosControllerTest < ActionDispatch::IntegrationTest

    test "Visitor should not get Todos Page" do
        get todos_url
        follow_redirect!
        assert_select "h1", {:count=>1, :text=>"Log in"}, "Wrong title or more than one h1 element"
    end

    test "should get index" do
        login_as users(:one)
        get todos_url
        assert_select "h2", {:count=>1, :text=>"Todo List"}, "Wrong title or more than one h2 element"
    end

    test "should not create Todo item with no time" do
        todo = Todo.new(title: "a")
        assert_not todo.save
    end

    test "should not create Todo item with no title" do
        todo = Todo.new(eta: 5.days.from_now.to_s)
        assert_not todo.save
    end
end
