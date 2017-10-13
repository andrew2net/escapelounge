class UserGamesController < ApplicationController
  before_action :set_user_game, only: [:step, :answer, :hint]
  before_action :set_step, only: [:step, :answer, :hint]

  # GET /user_games/:user_game_is/step(/:step_id)
  def step
    @game = @user_game.game
    step_answer = @step.step_answers.of_user(current_user.id).find_by(user_game_id: @user_game.id)
    if step_answer
      @answer = step_answer.answer
      @answered = true
    end
  end

  # POST /user_games/:user_game_id/step/:step_id/hint
  def hint
    hint = Hint.find params[:hint_id]
    @user_game.hints << hint
    @user_game.started_at -= hint.value.seconds
    @user_game.save
    render partial: 'hints'
  end

  # POST /user_games/:user_game_id/answer/:step_id
  def answer
    solution = @step.game_step_solutions.find_by solution: params[:answer]
    if solution
      StepAnswer.create user_game_id: @user_game.id, game_step_id: @step.id,
        answer: params[:answer]
      next_step = @step.next(current_user.id)
      if next_step
        redirect_to user_game_step_url(@user_game, next_step)
      else
        @user_game.finished_at = DateTime.now
        @user_game.result = ((@user_game.finished_at.to_datetime -
          @user_game.started_at.to_datetime) * 24 * 3600).to_i
        @user_game.save
        redirect_to user_game_result_url(@user_game)
      end
    else
      @answer = params[:answer]
      @game = @user_game.game
      render :step
    end
  end

  # GET /user_games/:user_game_id/result
  def result
    @user_game = current_user.user_games.find params[:user_game_id]
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_user_game
      @user_game = UserGame.find(params[:user_game_id])
    end

    def set_step
      @step = @user_game.game.allowed_step step_id: params[:step_id], user_id: current_user.id
      @step = @user_game.game.game_steps.first unless @step
    end

end
