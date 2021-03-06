# frozen_string_literal: true

require 'test_helper'

class SupervisorsOldTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @user2 = users(:two)
    @department = departments(:one)
    Old_DB.run("SET FOREIGN_KEY_CHECKS=0;")
    %i[chat_rooms chat_rooms_members users departments].each { |x| Old_DB.from(x).truncate }
    Old_DB.run("SET FOREIGN_KEY_CHECKS=1;")
  end

  test 'Normal create and delete supervisors' do
    @old_department = OldDepartment.create(name: @department.name, short_name: @department.code, status: 1)
    @department.sync_id = @old_department.id
    @department.save!
    assert_equal @department.sync_id, OldDepartment.last.id

    login_as users(:one)
    assert is_logged_in?

    get supervisors_path
    assert_difference 'OldUser.count', 1 do
      post supervisors_path, params: { supervisor: { name: 'Stupid Me', netID: 'stupid02', department_id: @department.id } }
      follow_redirect! while redirect?
    end

    @supervisor = Supervisor.find_by(name: 'Stupid Me')
    patch supervisor_path(@supervisor), params: { supervisor: { name: 'Stupid You', netID: 'stupid02', department_id: @department.id } }
    assert_equal 'Stupid You', OldUser[@supervisor.sync_id].common_name

    assert_difference 'OldUser.count', 0 do
      delete supervisor_path(@supervisor)
      follow_redirect! while redirect?
    end

    assert_equal 0, OldUser[common_name: 'Stupid You'].status
  end
end
