# frozen_string_literal: true

require 'test_helper'

class DepartmentOldTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @user2 = users(:two)
    @uni = universities(:one)
    %i[departments faculties universities].each { |x| Old_DB.from(x).truncate }

    @old_uni = OldUniversity.create(name: 'The Chinese University of Hong Kong', short_name: 'CUHK', status: 1)
    @fac = Faculty.create(name: 'Faculty of Balls', code: 'FBALL', university_id: @uni.id)
    @old_fac = OldFaculty.create(name: 'Faculty of Balls', short_name: 'FBALL', status: 1, university: @old_uni.id)
    @fac.sync_id = @old_fac.id
    @fac.save!
    assert_equal @fac.sync_id, OldFaculty.last.id
    login_as users(:two)
    assert is_logged_in?
  end

  test 'Normal create department' do
    assert_difference 'OldDepartment.count', 1 do
      post departments_path, params: { department: { name: 'Department of Justice', code: 'DOJ', faculty_id: @fac.id } }
      follow_redirect! while redirect?
    end

    assert_equal OldDepartment.last.id, Department.last.sync_id
    assert_equal @old_fac.id, OldDepartment.last.faculty
  end

  test 'Normal create and update department' do
    post departments_path, params: { department: { name: 'Department of Justice', code: 'DOJ', faculty_id: @fac.id } }
    follow_redirect! while redirect?
    assert_equal OldDepartment.last.id, Department.last.sync_id

    assert_difference 'OldDepartment.count', 0 do
      patch department_path(Department.last.id), params: { department: { name: 'Department of Justice', code: 'DOJ', faculty_id: 2, sync_id: Department.last.sync_id } }
      follow_redirect! while redirect?
    end

    assert_equal 99, OldDepartment.last.faculty
  end

  test 'Normal create and destroy department' do
    post departments_path, params: { department: { name: 'Department of Justice', code: 'DOJ', faculty_id: @fac.id } }
    follow_redirect! while redirect?

    assert_difference 'OldDepartment.count', 0 do
      delete department_path(Department.last.id)
      follow_redirect! while redirect?
    end

    assert_equal 2, OldDepartment.last.status
  end
end
