# frozen_string_literal: true

require 'test_helper'

class OldDbSyncTest < ActionDispatch::IntegrationTest
  def setup
    %i[users departments faculties universities].each { |x| Old_DB.from(x).truncate }
    OldDb.sync
  end

  test 'OldDb student modified' do
    sleep 1
    john = OldUser[1]
    john.common_name = 'John Dee'
    john.save

    OldDb.sync

    assert_equal 'John Dee', Student.find(1).name
  end

  test 'NewDb student modified' do
    sleep 1
    john = Student.find(1)
    john.name = 'John Derp'
    john.save

    OldDb.sync

    assert_equal 'John Derp', OldUser[1].common_name
  end

  test 'NewDb supervisor modified' do
    sleep 1
    john = Supervisor.first
    john.department = Department.second
    john.save

    OldDb.sync

    assert_equal Department.second.sync_id, OldUser[Supervisor.first.sync_id].department
  end

  test 'OldDb todo modified' do
    sleep 1
    item = OldTodo[Todo.first.sync_id]
    item.title = "Nope don't do it"
    item.save

    OldDb.sync

    assert_equal "Nope don't do it", Todo.first.title
  end
end
