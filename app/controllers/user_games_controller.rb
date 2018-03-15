class UserGamesController < ApplicationController
  before_action :set_user_game, only: [:step, :answer, :hint, :end, :result]
  before_action :set_step, only: [:step, :answer, :hint]
  before_action :set_progress, only: [:step, :result]

  # GET /user_games/:user_game_is/step(/:step_id)
  def step
    @game = @user_game.game
    @next_step = @step.next(@user_game.id)
    step_answer = @step.step_answers.find_by(user_game_id: @user_game.id)
    if step_answer
      @answer   = step_answer.answer
      @answered = true
    end
  end

  # POST /user_games/:user_game_id/step/:step_id/hint
  def hint
    @user_game.use_hint params[:hint_id]
    render partial: 'hints', locals: {
      user_game: @user_game,
      answered:  @answered,
      step:      @step,
      hints:     @user_game.hints.where(game_step_id: @step.id)
    }
  end

  # POST /user_games/:user_game_id/answer/:step_id
  def answer
    # check if the game is timeout
    if @user_game.finished_at
      render json: { result: "finish", redirect: user_game_result_url(@user_game) }
    else
      # check if the step is note empty (has solutions)
      if @step.game_step_solutions.any?
        answ = params[:answer].downcase.strip
        solution = @step.game_step_solutions.where('LOWER(solution) = ?', answ).first
        if solution
          sa = StepAnswer.find_or_initialize_by user_game_id: @user_game.id, game_step_id: @step.id
          sa.answer = answ
          sa.save
          next_step = @step.next(@user_game.id)
          url = if next_step
            user_game_step_url(@user_game, next_step)
          else
            @user_game.finish
            user_game_result_url @user_game
          end
          render json: { result: "success", redirect: url }
        else
          render json: { result: "fail" }
        end
      else
        # this step is last and empty
        @user_game.finish
        redirect_to user_game_result_url(@user_game)
      end
    end
  end

  # POST /user_games/:user_game_id/end
  def end
    @user_game.finish 0
    redirect_to user_game_result_path @user_game
  end

  # GET /user_games/:user_game_id/result
  def result
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_user_game
      @user_game = UserGame.find(params[:user_game_id])
    end

    def set_step
      @step = @user_game.game.allowed_step step_id: params[:step_id], user_game_id: @user_game.id
      # If there is no any answered step then set first step.
      @step = @user_game.game.game_steps.first unless @step
    end

    def set_progress
      @progress_pescent, @progress_step = @user_game.progress
    end
end
