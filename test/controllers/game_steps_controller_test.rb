require 'test_helper'

class GameStepsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @game_step = game_steps(:one)
    @user = users :one
    sign_in @user
  end

  test "should get index" do
    get game_steps_url
    assert_response :success
  end

  test "should get new" do
    get new_game_step_url
    assert_response :success
  end

  test "should create game_step" do
    assert_difference('GameStep.count') do
      post game_steps_url, params: { game_step: { description: @game_step.description, game_id: @game_step.game_id, name: @game_step.name } }
    end

    assert_redirected_to game_step_url(@game_step.game.game_steps.last)
  end

  test "should show game_step" do
    get game_step_url(@game_step)
    assert_response :success
  end

  test "should get edit" do
    get edit_game_step_url(@game_step)
    assert_response :success
  end

  test "should update game_step" do
    patch game_step_url(@game_step), params: { game_step: { description: @game_step.description, game_id: @game_step.game_id, name: @game_step.name } }
    assert_redirected_to game_step_url(@game_step)
  end

  test "should destroy game_step" do
    assert_difference('GameStep.count', -1) do
      delete game_step_url(@game_step)
    end

    assert_redirected_to game_steps_url
  end
end
