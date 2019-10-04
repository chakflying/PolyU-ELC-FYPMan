# frozen_string_literal: true

require 'test_helper'

class GroupsOldTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @user2 = users(:two)
    @student = students(:one)
    @supervisor = supervisors(:one)
    @department = Department.find(16)
    Old_DB.run('SET FOREIGN_KEY_CHECKS=0;')
    %i[chat_rooms chat_rooms_members users departments].each { |x| Old_DB.from(x).truncate }
    Old_DB.run('SET FOREIGN_KEY_CHECKS=1;')
  end

  test 'Simulated Create Group' do
    @old_department = OldDepartment.create(name: @department.name, short_name: @department.code, status: 1)
    @department.sync_id = @old_department.id
    @department.save!
    assert_equal @department.sync_id, OldDepartment.last.id

    @old_student = OldUser.create(common_name: @student.name, net_id: @student.netID, department: @old_department.id, FYPyear: @student.fyp_year, status: 1, role: 1, uuid: 0, program_code: 0, subject_code: 0, senior_year: 0)
    Student.first.update(sync_id: @old_student.id)
    @old_supervisor = OldUser.create(common_name: @supervisor.name, net_id: @supervisor.netID, department: @old_department.id, status: 1, role: 2, uuid: 0, program_code: 0, subject_code: 0, senior_year: 0)
    Supervisor.first.update(sync_id: @old_supervisor.id)

    login_as users(:one)
    assert is_logged_in?

    get groups_path
    assert_difference 'OldChatRoom.count', 1 do
      post groups_path, params: { group: { number: 87 } }
      follow_redirect! while redirect?
    end

    assert_difference 'OldChatRoom.count', 1 do
      post create_group_and_add_path, params: { group: { number: nil }, student_ids: [Student.second.id], supervisor_ids: [nil] }
    end

    get groups_path
    assert_difference 'OldChatRoomMember.count', 2 do
      post create_group_and_add_path, params: { group: { number: 33 }, student_ids: [Student.first.id], supervisor_ids: [Supervisor.first.id] }
    end

    get groups_path
    assert_difference 'OldChatRoomMember.count', 0 do
      post create_group_and_add_path, params: { group: { number: nil }, student_ids: [Student.second.id], supervisor_ids: [Supervisor.second.id] }
    end

    delete groups_students_path, params: { groups_student: { group_id: Group.find_by(number: 33).id, student_id: Student.first.id } }
    assert_equal 0, OldChatRoomMember[chat_room_id: Group.find_by(number: 33).sync_id, user_id: Student.first.sync_id].status
  end
end
