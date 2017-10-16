class UserGamesController < ApplicationController
  before_action :set_user_game, only: [:step, :answer, :hint, :end, :result]
  before_action :set_step, only: [:step, :answer, :hint]

  # GET /user_games/:user_game_is/step(/:step_id)
  def step
    @game = @user_game.game
    @progress_pescent, @progress_step = @user_game.progress
    step_answer = @step.step_answers.find_by(user_game_id: @user_game.id)
    if step_answer
      @answer = step_answer.answer
      @answered = true
    end
  end

  # POST /user_games/:user_game_id/step/:step_id/hint
  def hint
    @user_game.use_hint params[:hint_id]
    render partial: 'hints'
  end

  # POST /user_games/:user_game_id/answer/:step_id
  def answer
    if @user_game.finished_at
      redirect_to user_game_result_url @user_game
    else
      solution = @step.game_step_solutions.find_by solution: params[:answer]
      if solution
        StepAnswer.create user_game_id: @user_game.id, game_step_id: @step.id,
          answer: params[:answer]
        next_step = @step.next(@user_game.id)
        if next_step
          redirect_to user_game_step_url(@user_game, next_step)
        else
          @user_game.finish
          redirect_to user_game_result_url @user_game
        end
      else
        @answer = params[:answer]
        @game = @user_game.game
        flash.now[:alert] = "The answer is not correct."
        render :step
      end
    end
  end

  # POST /user_games/:user_game_id/end
  def end
    @user_game.finish
  end

  # GET /user_games/:user_game_id/result
  def result
    @progress_pescent, @progress_step = @user_game.progress
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_user_game
      @user_game = UserGame.find(params[:user_game_id])
    end

    def set_step
      @step = @user_game.game.allowed_step step_id: params[:step_id], user_id: current_user.id
      # If there is no any answered step then set first step.
      @step = @user_game.game.game_steps.first unless @step
    end
end
