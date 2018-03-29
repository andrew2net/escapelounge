class UserGamesController < ApplicationController
  before_action :set_user_game, only: [:step, :answer, :hint, :end, :result]
  before_action :set_step, only: [:step, :answer, :hint]
  before_action :set_progress, only: [:step, :result]

  # GET /user_games/:user_game_is/step(/:step_id)
  def step
    @game        = @user_game.game
    @next_step   = @step.next(@user_game.id)
    step_answers = @user_game.step_answers
      .where(game_step_solution_id: @step.game_step_solutions.ids)
    if step_answers.any?
      @answer   = step_answers.first.answer
      @answered = true
    end
    join = "LEFT JOIN step_answers ON step_answers.game_step_solution_id=game_step_solutions.id"\
           " AND step_answers.user_game_id=#{@user_game.id}"
    @questions = @step.game_step_solutions
      .select("game_step_solutions.*, step_answers.answer").joins(join)
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
        if @step.multi_questions?
          results = true
          params[:questions].each do |question_id, answer|
            solution = @step.game_step_solutions.find question_id
            solutions = solution.solution.downcase.split
            results &= solutions.include? answer[:answer].downcase
          end
          if results
            params[:questions].each do |question_id, answer|
              sa = StepAnswer.find_or_initialize_by user_game_id: @user_game.id,
                game_step_solution_id: question_id
              sa.answer = answer[:answer]
              sa.save
            end
            render json: { result: "success", redirect: next_url }
          else
            render json: { result: "fail" }
          end
        else
          answ = params[:answer].downcase.strip
          solution = @step.game_step_solutions.where('LOWER(solution) = ?', answ).first
          if solution
            sa = StepAnswer.find_or_initialize_by user_game_id: @user_game.id,
                                                  game_step_solution_id: solution.id
            sa.answer = answ
            sa.save
            render json: { result: "success", redirect: next_url }
          else
            render json: { result: "fail" }
          end
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

    def next_url
      next_step = @step.next(@user_game.id)
      if next_step
        user_game_step_url(@user_game, next_step)
      else
        @user_game.finish
        user_game_result_url @user_game
      end
    end
end
