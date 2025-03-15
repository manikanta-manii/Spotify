require "test_helper"

class Admin::SongsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_songs_index_url
    assert_response :success
  end

  test "should get new" do
    get admin_songs_new_url
    assert_response :success
  end

  test "should get create" do
    get admin_songs_create_url
    assert_response :success
  end

  test "should get edit" do
    get admin_songs_edit_url
    assert_response :success
  end

  test "should get update" do
    get admin_songs_update_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_songs_destroy_url
    assert_response :success
  end
end
