class GamesController < ApplicationController
  before_action :set_game, only: [:show]

  # GET /games
  def index
    @games = Game.visible.allowed current_user
  end

  # POST /games/table
  # return filtered games list
  def games
    @games = Game.includes(:grades).visible.where filter_params
    @games = @games.allowed current_user if params[:allowed_filter] == "true"
    render @games
  end

  # GET /games/:id
  def show
    @display_pause_buttons = true
  end

  # POST /games/:game_id/start
  def start
    user_game = current_user.user_games.paused.find_by(game_id: params[:game_id])
    # Start new usergame if there isn't started this type of game and no running other game
    if !user_game && !current_user.user_games.running.any?
      game = Game.find params[:game_id]
      authorize game
      user_game = UserGame.new(user_id: current_user.id, game_id: game.id)
      user_game.started_at = params[:start_at]
      user_game.save
      redirect_to user_game_step_url(user_game)
    else
      @game = Game.find params[:game_id]
      flash.now[:notice] = "Other game is running."
      render :shower
    end
  rescue Pundit::NotAuthorizedError
    redirect_to game_path(params[:game_id]), notice: "You have not subscription to start the game."
  end

  # POST /games/:game_id/pause
  def pause
    user_game = !current_user.nil? && current_user.user_games.running.find_by(game_id: params[:game_id])
    user_game.update paused_at: params[:seconds_remain] if user_game
    head :ok
  end

  # POST /games/:game_id/resume
  def resume
    user_game = !current_user.nil? && current_user.user_games.paused.find_by(game_id: params[:game_id])
    if user_game && !current_user.user_games.running.any?
      passed_seconds = user_game.game.time_length.to_i * 60 - user_game.paused_at
      started_at = DateTime.parse(params[:start_at]) - passed_seconds.seconds
      user_game.update started_at: started_at, paused_at: nil
    end
    # head :ok
    redirect_to user_game_step_url(user_game, user_game && user_game.last_allowed_step)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    def filter_params
      fp = params.require(:filter).permit(:difficulty, :grade_id)
        .select { |_k, v| !v.blank? }
      fp[:games_grades] = { grade_id: fp.delete(:grade_id) } if fp[:grade_id]
      fp
    end
end
