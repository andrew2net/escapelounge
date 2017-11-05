require "test_helper"

class UserGamesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user_game = user_games(:two)
    @user = users :two
    sign_in @user
  end

  test "should get first step of the game" do
    step = @user_game.game.game_steps.first
    get user_game_step_url @user_game
    assert_response :success
    assert_includes response.body, step.description
    assert_includes response.body, "Next step"
    assert_not_includes response.body, "Previous step"
  end

  test "should get step of the game" do
    step = @user_game.game.game_steps.last
    get user_game_step_url @user_game, step
    assert_response :success
    assert_includes response.body, step.description
    assert_not_includes response.body, "Next step"
    assert_includes response.body, "Previous step"
  end

  test "should get first unanswered step of the game" do
    StepAnswer.delete_all
    first_step = @user_game.game.game_steps.first
    step = @user_game.game.game_steps.last
    get user_game_step_url @user_game, step
    assert_response :success
    assert_not_includes response.body, step.description
    assert_includes response.body, first_step.description
    assert_not_includes response.body, "Next step"
    assert_not_includes response.body, "Previous step"
  end

  test "should return hint" do
    hint = hints :one
    assert_difference "@user_game.hints.count" do
      post user_game_step_hint_url(@user_game, hint), params: { hint_id: hint.id }
    end
    assert_response :success
    assert_includes response.body, hint.description
  end

  test "should post success answer" do
    StepAnswer.delete_all
    step = @user_game.game.game_steps.first
    solution = step.game_step_solutions.first
    assert_difference "@user_game.step_answers.count" do
      post user_game_step_url(@user_game, step), params: { answer: solution.solution }
    end
    assert_response :success
    assert_equal JSON.parse(response.body)["result"], "success"
  end

  test "should post wrong answer" do
    step = @user_game.game.game_steps.first
    assert_no_difference "@user_game.step_answers.count" do
      post user_game_step_url(@user_game, step), params: { answer: "Wrong answer" }
    end
    assert_response :success
    assert_equal JSON.parse(response.body)["result"], "fail"
  end

  test "should finish if the game is finished" do
    @user_game.finish
    step = @user_game.game.game_steps.first
    solution = step.game_step_solutions.first
    assert_no_difference "@user_game.step_answers.count" do
      post user_game_step_url(@user_game, step), params: { answer: solution.solution }
    end
    assert_response :success
    assert_equal JSON.parse(response.body)["result"], "finish"
  end

  test "shoud end the game" do
    post user_game_end_url(@user_game)
    assert_redirected_to user_game_result_path(@user_game)
    @user_game.reload
    assert_not_nil @user_game.finished_at
    assert_equal @user_game.result, 0
  end

  test "should get result page with finished game" do
    # Make the user game stared 5 minutes ago
    @user_game.started_at -= 5.minutes
    @user_game.save
    @user_game.finish
    get user_game_result_url @user_game
    @user_game.reload
    assert_response :success
    assert_includes response.body, "Result"
    assert @user_game.result > 0
  end

  test "should get result page with ended game" do
    @user_game.finish 0
    get user_game_result_url @user_game
    @user_game.reload
    assert_response :success
    assert_includes response.body, "Ended"
    assert_equal @user_game.result, 0
  end

  test "should get result page with timeouted game" do
    @user_game.update finished_at: DateTime.now
    get user_game_result_url @user_game
    @user_game.reload
    assert_response :success
    assert_includes response.body, "Time expired"
    assert_nil @user_game.result
  end
end
