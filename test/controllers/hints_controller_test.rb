require 'test_helper'

class HintsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @hint = hints(:one)
    @user = users :one
    sign_in @user
  end

  test "should get index" do
    get hints_url
    assert_response :success
  end

  test "should get new" do
    get new_hint_url
    assert_response :success
  end

  test "should create hint" do
    assert_difference('Hint.count') do
      post hints_url, params: { hint: { description: @hint.description, game_step_id: @hint.game_step_id, value: @hint.value } }
    end

    assert_redirected_to hint_url(Hint.last)
  end

  test "should show hint" do
    get hint_url(@hint)
    assert_response :success
  end

  test "should get edit" do
    get edit_hint_url(@hint)
    assert_response :success
  end

  test "should update hint" do
    patch hint_url(@hint), params: { hint: { description: @hint.description, game_step_id: @hint.game_step_id, value: @hint.value } }
    assert_redirected_to hint_url(@hint)
  end

  test "should destroy hint" do
    assert_difference('Hint.count', -1) do
      delete hint_url(@hint)
    end

    assert_redirected_to hints_url
  end
end
