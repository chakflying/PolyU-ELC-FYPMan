# frozen_string_literal: true

require 'test_helper'

class TodosCreateTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @user2 = users(:two)
    @todo = todos(:two)
  end

  test 'non admin create and destroy todos' do
    login_as users(:one)
    assert is_logged_in?

    get todos_path
    assert_difference 'Todo.count', 1 do
      post todos_path, params: { todo: { title: 'Short Life, too much To Do', description: 'damn.', eta: 3.days.from_now.to_s, department_id: departments(:one).id } }
      follow_redirect! while redirect?
    end
    assert_difference 'Todo.count', -1 do
      delete todo_path(Todo.last.id)
      follow_redirect! while redirect?
    end
  end

  test 'non admin attempt to create global todos' do
    login_as users(:one)
    assert is_logged_in?

    get todos_path
    assert_difference 'Todo.count', 1 do
      post todos_path, params: { todo: { title: @todo.title, description: @todo.description, eta: @todo.eta, department_id: '' } }

      follow_redirect! while redirect?
    end
    assert_equal @user.department.id, Todo.last.department.id
  end

  test 'admin create global todos' do
    login_as users(:two)
    assert is_logged_in?

    get todos_path
    assert_difference 'Todo.count', 1 do
      post todos_path, params: { todo: { title: @todo.title, description: @todo.description, eta: @todo.eta, department_id: '' } }

      follow_redirect! while redirect?
    end
    assert_nil Todo.last.department
  end
end
