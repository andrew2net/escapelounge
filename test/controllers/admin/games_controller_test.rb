require "test_helper"

class Admin::GamesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @game = games(:one)
    @user = users :one
  end

  test "should get new" do
    get new_admin_game_url
    assert_response :success
  end

  test "should create game" do
    assert_difference('Game.count') do
      post admin_games_url, params: { game: { age_range: @game.age_range, description: @game.description, difficulty: @game.difficulty, name: @game.name, status: @game.status, time_length: @game.time_length } }
    end

    assert_redirected_to game_url(Game.last)
  end

  test "should get edit" do
    get edit_admin_game_url(@game)
    assert_response :success
  end

  test "should update game" do
    patch admin_game_url(@game), params: { game: { age_range: @game.age_range, description: @game.description, difficulty: @game.difficulty, name: @game.name, status: @game.status, time_length: @game.time_length } }
    assert_redirected_to game_url(@game)
  end

  test "should destroy game" do
    assert_difference('Game.count', -1) do
      delete admin_game_url(@game)
    end

    assert_redirected_to admin_games_url
  end
end
