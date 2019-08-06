require 'test_helper'

class GroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group = groups(:one)
  end

  test "guest should not get index" do
    get groups_url
    assert_redirected_to root_url
  end

  test "should get index" do
    login_as users(:two)
    get groups_url
    assert_response :success
  end

  test "should create group" do
    login_as users(:two)
    assert_difference('Group.count') do
      post groups_url, params: { group: { number: @group.number, sync_id: @group.sync_id } }
    end

    assert_redirected_to group_url(Group.last)
  end

  test "should show group" do
    login_as users(:two)
    get group_url(@group)
    assert_response :success
  end

  test "should update group" do
    login_as users(:two)
    patch group_url(@group), params: { group: { number: @group.number, sync_id: @group.sync_id } }
    assert_redirected_to group_url(@group)
  end

  test "should destroy group" do
    login_as users(:two)
    assert_difference('Group.count', -1) do
      delete group_url(@group)
    end

    assert_redirected_to groups_url
  end
end
