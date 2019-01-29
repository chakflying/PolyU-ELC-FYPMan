# frozen_string_literal: true

require 'test_helper'

class TodosControllerTest < ActionDispatch::IntegrationTest
  test 'Visitor should not get Todos Page' do
    get todos_url
    follow_redirect!
    assert_select 'h1', { count: 1, text: 'Log in' }, 'Wrong title or more than one h1 element'
  end

  test 'should get index' do
    login_as users(:one)
    get todos_url
    assert_select 'h2', { count: 1, text: 'Todo List' }, 'Wrong title or more than one h2 element'
  end

  test 'should not create Todo item with no time' do
    login_as users(:one)
    assert_difference 'Todo.count', 0 do
      post todos_path, params: { todo: { title: 'Short Life, too much To Do', description: 'damn.', department_id: departments(:one).id } }
      follow_redirect! while redirect?
    end
    assert_select 'h2', { count: 1, text: 'Todo List' }, 'Wrong title or more than one h2 element'
    assert_equal ['Todo date cannot be empty. Please set date.'], flash[:danger]
  end

  test 'should not create Todo item with no title' do
    login_as users(:one)
    assert_difference 'Todo.count', 0 do
      post todos_path, params: { todo: { color: 'success', description: 'damn.', eta: 3.days.from_now.to_s(:db), department_id: departments(:one).id } }
      follow_redirect! while redirect?
    end
    assert_select 'h2', { count: 1, text: 'Todo List' }, 'Wrong title or more than one h2 element'
    assert_equal ['Todo title cannot be empty. Please enter title.'], flash[:danger]
  end

  test 'should create normal Todo item' do
    login_as users(:one)
    assert_difference 'Todo.count', 1 do
      post todos_path, params: { todo: { title: 'Short Life, too much To Do', color: 'success', description: 'damn.', eta: 3.days.from_now.to_s(:db), department_id: departments(:one).id } }
      follow_redirect! while redirect?
    end
    assert_select 'h2', { count: 1, text: 'Todo List' }, 'Wrong title or more than one h2 element'
    assert_equal ['Todo item successfully added!'], flash[:success]

    assert_difference 'Todo.count', -1 do
      delete todo_path(Todo.last.id)
      follow_redirect! while redirect?
    end
    assert_equal ['Todo item deleted.'], flash[:success]
  end
end
