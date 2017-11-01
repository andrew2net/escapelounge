require 'test_helper'

class GamesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @game = games :two
    @user = users :two
   sign_in @user
  end

  test "should get index" do
    get games_url
    assert_response :success
  end

  test "should return only games with difficulty 1" do
    post games_games_url, params: { filter: { difficulty: 1 } }, xhr: true
    assert_select '.game-container' do |element|
      assert_select element, 'p:nth-child(5)', 'Difficulty: 2 (easy)'
    end
  end

  test "should return only games with grade 1" do
    grade = grades :two
    post games_games_url, params: { filter: { grade_id: grade.id } }, xhr: true
    assert_select '.game-container' do |element|
      assert_select element, 'p:nth-child(6)', "Grades: \n#{grade.name}"
    end
  end

  test "should show running game" do
    @user.update subscription_plan: subscription_plans(:two), period_end: (DateTime.now + 1.day)
    get game_url(@game)
    assert_response :success
    assert_select '#container-timer[style=""]'
    assert_select '#pause-game-btn[style=""]', 1
    assert_select '#resume-game-btn[style*="display:none"]'
    assert_select 'button[data-target="#start-game-modal"][style*="display:none"]', 'Start game'
  end

  test "should show paused game" do
    @user.user_games.find_by(game_id: @game.id).update(paused_at: 1)
    @user.update subscription_plan: subscription_plans(:two), period_end: (DateTime.now + 1.day)
    get game_url @game
    assert_response :success
    assert_select '#container-timer[style=""]'
    assert_select '#pause-game-btn[style*="display:none"]'
    assert_select '#resume-game-btn[style*=""]'
    assert_select 'button[data-target="#start-game-modal"][style*="display:none"]', 'Start game'
  end

  test "should show stoped game" do
    @user.user_games.find_by(game_id: @game.id).update(finished_at: DateTime.now)
    @user.update subscription_plan: subscription_plans(:two), period_end: (DateTime.now + 1.day)
    get game_url @game
    assert_response :success
    assert_select '#container-timer[style*="display:none"]'
    assert_select 'button[data-target="#start-game-modal"][style=""]', 'Start game'
  end

  test "should not show start button" do
    get game_url @game
    assert_response :success
    assert_includes response.body, "You have no subscription to start the game."
  end

  test "should start a game" do
    @user.update subscription_plan: subscription_plans(:two), period_end: (DateTime.now + 1.day)
    user_game = @game.user_games.find_by(user_id: @user.id)
    # Finish user game because it created started in fixture.
    user_game.update finished_at: DateTime.now
    time = DateTime.now
    post game_start_url @game, params: { start_at: time }
    assert_redirected_to user_game_step_url UserGame.last
  end

  test "shoud not start a game because there isn't apropriate subscription" do
    @user.update period_end: (DateTime.now + 1.day)
    user_game = @game.user_games.find_by(user_id: @user.id)
    # Finish user game because it created started in fixture.
    user_game.update finished_at: DateTime.now
    time = DateTime.now
    post game_start_url @game, params: { start_at: time }
    assert_redirected_to game_path(@game)
  end

  test "shoud not start a game because subscription is expired" do
    @user.update subscription_plan: subscription_plans(:two), period_end: (DateTime.now - 1.day)
    user_game = @game.user_games.find_by(user_id: @user.id)
    # Finish user game because it created started in fixture.
    user_game.update finished_at: DateTime.now
    time = DateTime.now
    post game_start_url @game, params: { start_at: time }
    assert_redirected_to game_path(@game)
  end

  test "shoud pause a game" do
    post game_pause_url @game, params: { seconds_remain: 600 }, xhr: true
    assert_response :success
    assert_not_nil @user.user_games.find_by(game_id: @game.id).paused_at
  end

  test "should resume a game" do
    post game_resume_url @game, params: { start_at: DateTime.now }, xhr: true
    assert_response :success
    assert_nil @user.user_games.find_by(game_id: @game.id).paused_at
  end
end
