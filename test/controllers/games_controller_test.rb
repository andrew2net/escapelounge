require 'test_helper'

class GamesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @game = games(:one)
    @user = users :one
  end

  test "should get index" do
    get games_url
    assert_response :success
  end

  test "should return only games with difficulty 1" do
    post table_games_url, params: { filter: { difficulty: 1 } }, xhr: true
    assert_select 'tr' do |element|
      assert_select element, 'td:nth-child(4)', '2 (easy)'
    end
  end

  test "should return only games with age_range 1" do
    post table_games_url, params: { filter: { age_range: 1 } }, xhr: true
    assert_select 'tr' do |element|
      assert_select element, 'td:nth-child(5)', 'ages 10 - 14'
    end
  end

  test "should get new" do
    get new_game_url
    assert_response :success
  end

  test "should create game" do
    assert_difference('Game.count') do
      post games_url, params: { game: { age_range: @game.age_range, description: @game.description, difficulty: @game.difficulty, name: @game.name, status: @game.status, time_length: @game.time_length } }
    end

    assert_redirected_to game_url(Game.last)
  end

  test "should show running game" do
    sign_in @user
    get game_url(@game)
    assert_response :success
    assert_select '#container-timer[style=""]'
    assert_select '#pause-game-btn[style=""]', 1
    assert_select '#resume-game-btn[style*="display:none"]'
    assert_select '#start-game-btn[style*="display:none"]', 'Start game'
  end

  test "should show paused game" do
    sign_in @user
    @user.user_games.find_by(game_id: @game.id).update(paused_at: 1)
    get game_url @game
    assert_response :success
    assert_select '#container-timer[style=""]'
    assert_select '#pause-game-btn[style*="display:none"]'
    assert_select '#resume-game-btn[style*=""]'
    assert_select '#start-game-btn[style*="display:none"]', 'Start game'
  end

  test "should show stoped game" do
    sign_in @user
    @user.user_games.find_by(game_id: @game.id).update(finished_at: DateTime.now)
    get game_url @game
    assert_response :success
    assert_select '#container-timer[style*="display:none"]'
    assert_select '#start-game-btn[style=""]', 'Start game'
  end

  test "should start a game" do
    sign_in @user
    @game.user_games.find_by(user_id: @user.id).update finished_at: DateTime.now
    time = DateTime.now
    get game_start_url @game, params: { start_at: time }, xhr: true
    # assert JSON.parse(response.body).key? 'stop_at'
    assert_redirected_to game_steps_flow_url @game
   end

   test "shoud pause a game" do
     sign_in @user
     post game_pause_url @game, params: { seconds_remain: 600 }, xhr: true
     assert_response :success
     assert_not_nil @user.user_games.find_by(game_id: @game.id).paused_at
   end

   test "should resume a game" do
     sign_in @user
     post game_resume_url @game, params: { start_at: DateTime.now }, xhr: true
     assert_response :success
     assert_nil @user.user_games.find_by(game_id: @game.id).paused_at
   end

  test "should get edit" do
    get edit_game_url(@game)
    assert_response :success
  end

  test "should update game" do
    patch game_url(@game), params: { game: { age_range: @game.age_range, description: @game.description, difficulty: @game.difficulty, name: @game.name, status: @game.status, time_length: @game.time_length } }
    assert_redirected_to game_url(@game)
  end

  test "should destroy game" do
    assert_difference('Game.count', -1) do
      delete game_url(@game)
    end

    assert_redirected_to games_url
  end
end
