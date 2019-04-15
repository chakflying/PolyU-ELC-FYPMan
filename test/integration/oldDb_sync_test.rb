# frozen_string_literal: true

require 'test_helper'

class OldDbSyncTest < ActionDispatch::IntegrationTest
  def setup
    %i[users departments faculties universities todos].each { |x| Old_DB.from(x).truncate }
    OldDepartment.create(name: "Department of Justice", short_name: "DOJ", status: 1)
    OldDb.sync
  end

  test 'OldDb student modified' do
    Timecop.travel 3.second.since
    john = OldUser[1]
    john.common_name = 'John Dee'
    john.save

    OldDb.sync

    assert_equal 'John Dee', Student.find(1).name
  end

  test 'NewDb student modified' do
    Timecop.travel 3.second.since
    john = Student.find(1)
    john.name = 'John Derp'
    john.save

    OldDb.sync

    assert_equal 'John Derp', OldUser[1].common_name
  end

  test 'NewDb supervisor modified' do
    Timecop.travel 3.second.since
    john = Supervisor.first
    john.department = Department.second
    john.save

    OldDb.sync

    assert_equal Department.second.sync_id, OldUser[Supervisor.first.sync_id].department
  end

  test 'OldDb todo created' do
    Timecop.travel 3.second.since
    item = OldTodo.create(title: "Sync is good?", time: 1.day.from_now, issued_department: OldDepartment[short_name: "DOJ"].id, status: 1)

    OldDb.sync

    assert_equal "Sync is good?", Todo.last.title
    assert_equal "Department of Justice", Department.find(Todo.last.department.id).name
  end

  test 'OldDb todo modified' do
    Timecop.travel 3.second.since
    item = OldTodo[Todo.first.sync_id]
    item.title = "Nope don't do it"
    item.save

    OldDb.sync

    assert_equal "Nope don't do it", Todo.first.title
  end

  test 'OldDb todo deleted' do
    Timecop.travel 3.second.since
    item = OldTodo[Todo.first.sync_id]

    assert_difference 'Todo.count', -1 do
      item.delete
      OldDb.sync
    end
  end

  test 'OldDb faculty deleted' do
    Timecop.travel 3.second.since
    assert_equal 2, OldFaculty.count

    item = OldFaculty[Faculty.last.sync_id]
    
    assert_difference 'Faculty.count', -1 do
      item.delete
      OldDb.sync
    end
  end

  test 'OldDb university deleted' do
    Timecop.travel 3.second.since
    assert_equal 2, OldUniversity.count

    item = OldUniversity[University.last.sync_id]
    
    assert_difference 'University.count', -1 do
      item.delete
      OldDb.sync
    end
  end
end
