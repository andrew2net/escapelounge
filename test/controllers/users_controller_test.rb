require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    sign_in @user
    assert_difference('User.count') do
      post users_url, params: { user: { name: @user.name, email: "test@mail.net", password: '12345678', password_confirmation: '12345678' } }
    end

    assert_redirected_to user_url(User.last)
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    sign_in @user
    patch user_url(@user), params: { user: { name: @user.name } }
    assert_redirected_to user_url(@user)
  end

  test "should destroy user" do
    sign_in @user
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end
end
