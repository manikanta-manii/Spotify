require "test_helper"

class Admin::AlbumsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_albums_index_url
    assert_response :success
  end

  test "should get new" do
    get admin_albums_new_url
    assert_response :success
  end

  test "should get create" do
    get admin_albums_create_url
    assert_response :success
  end

  test "should get edit" do
    get admin_albums_edit_url
    assert_response :success
  end

  test "should get update" do
    get admin_albums_update_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_albums_destroy_url
    assert_response :success
  end
end
