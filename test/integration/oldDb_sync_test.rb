# frozen_string_literal: true

require 'test_helper'

class OldDbSyncTest < ActionDispatch::IntegrationTest
  def setup
    Old_DB.run("SET FOREIGN_KEY_CHECKS=0;")
    %i[chat_rooms chat_rooms_members users departments faculties universities todos].each { |x| Old_DB.from(x).truncate }
    Old_DB.run("SET FOREIGN_KEY_CHECKS=1;")
    OldDepartment.create(name: "Department of Justice", short_name: "DOJ", status: 1)
    OldDb.sync
  end

  test 'OldDb student modified' do
    Timecop.travel 3.second.since
    john = OldUser[students(:one).sync_id]
    john.common_name = 'John Dee'
    john.save

    OldDb.sync

    assert_equal 'John Dee', Student.find(students(:one).id).name
  end

  test 'NewDb student modified' do
    Timecop.travel 3.second.since
    john = Student.find(students(:one).id)
    john.name = 'John Derp'
    john.save

    OldDb.sync

    assert_equal 'John Derp', OldUser[john.sync_id].common_name
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
    item = OldTodo.create(title: "Sync is good?", time: 1.day.from_now, issued_department: OldDepartment[short_name: "DOJ"].id, status: 1, scope: 1)

    OldDb.sync

    assert_equal "Sync is good?", Todo.last.title
    assert_equal "Department of Justice", Department.find(Todo.last.department.id).name
  end

  test 'OldDB non department todo does not sync' do
    Timecop.travel 3.second.since
    assert_difference 'Todo.count', 0 do
      item = OldTodo.create(title: "Todo for students", time: 1.day.from_now, issued_department: OldDepartment[short_name: "DOJ"].id, status: 1, scope: 2)
      OldDb.sync
    end
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
      item.destroy
      OldDb.sync
    end
  end

  test 'OldDb faculty deleted' do
    Timecop.travel 3.second.since
    assert_equal 2, OldFaculty.count

    item = OldFaculty[Faculty.last.sync_id]
    
    assert_difference 'Faculty.count', -1 do
      OldDepartment.where(faculty: item.id).destroy
      item.destroy
      OldDb.sync
    end
  end

  test 'OldDb university deleted' do
    Timecop.travel 3.second.since
    assert_equal 2, OldUniversity.count

    item = OldUniversity[University.last.sync_id]
    
    assert_difference 'University.count', -1 do
      OldFaculty.where(university: item.id).each do |fac|
        OldDepartment.where(faculty: fac.id).destroy
        fac.destroy
      end
      item.destroy
      OldDb.sync
    end
  end

  test 'OldDb group created and destroyed' do
    Timecop.travel 3.second.since
    group = OldChatRoom.create(status: 1, room_type: "group")
    assert_difference 'Group.count', 1 do
      OldDb.sync
    end
    assert_difference 'Group.count', -1 do
      group.update(status: 2)
      OldDb.sync
    end
  end

  test 'OldDb group add and remove member' do
    Timecop.travel 3.second.since
    group = OldChatRoom.create(status: 1, room_type: "group")
    assert_difference 'GroupsStudent.count', 1 do
      OldChatRoomMember.create(status: 1, chat_room_id: group.id, user_id: Student.first.sync_id)
      OldDb.sync
    end
    assert_difference 'GroupsSupervisor.count', 1 do
      OldChatRoomMember.create(status: 1, chat_room_id: group.id, user_id: Supervisor.first.sync_id)
      OldDb.sync
    end
    assert_difference 'GroupsSupervisor.count', -1 do
      OldChatRoomMember[chat_room_id: group.id, user_id: Supervisor.first.sync_id].update(status: 2)
      OldDb.sync
    end
  end

  test 'OldDb group dont sync individual group' do
    Timecop.travel 3.second.since
    group = OldChatRoom.create(status: 1, room_type: "individual")
    assert_difference 'Group.count', 0 do
      OldDb.sync
    end
  end
end
