# frozen_string_literal: true

require 'test_helper'

class TodosOldTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @user2 = users(:two)
    @todo = todos(:two)
    [:todos].each { |x| Old_DB.from(x).truncate }
  end

  test 'Normal create and delete todos' do
    login_as users(:one)
    assert is_logged_in?

    get todos_path
    assert_difference 'OldTodo.count', 1 do
      post todos_path, params: { todo: { title: 'Stupid Me', description: "I didn't even know how testing worked", eta: 1.day.from_now, department_id: @todo.department_id } }
      follow_redirect! while redirect?
    end

    @new_todo = Todo.last
    patch todo_path(@new_todo), params: { todo: { title: 'Stupid You', department_id: @todo.department_id } }
    assert_equal 'Stupid You', OldTodo.last.title

    assert_difference 'OldTodo.count', 0 do
      delete todo_path(@new_todo)
      follow_redirect! while redirect?
    end

    assert_equal 2, OldTodo[title: 'Stupid You'].status
  end

  test 'Create and delete non department todos' do
    login_as users(:one)
    assert is_logged_in?

    get todos_path
    assert_difference 'OldTodo.count', 1 do
      post todos_path, params: { todo: { title: 'Stupid Me', description: "I didn't even know how testing worked", eta: 1.day.from_now, department_id: '' } }
      follow_redirect! while redirect?
    end

    @new_todo = Todo.last
    patch todo_path(@new_todo), params: { todo: { title: 'Stupid Everyone  ', department_id: '' } }
    assert_equal 'Stupid Everyone', OldTodo.last.title

    assert_difference 'OldTodo.count', 0 do
      delete todo_path(@new_todo)
      follow_redirect! while redirect?
    end

    assert_equal 2, OldTodo[title: 'Stupid Everyone'].status
  end
end
