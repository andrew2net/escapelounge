class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  def index
    @games = Game.visible
  end

  # POST /games/table
  def table
    @games = Game.visible.where filter_params
    render partial: 'table_body'
  end

  def games_admin_list
    @games = Game.all
  end

  # GET /games/:id
  def show
    # This need for finishing expired game.
    current_user && current_user.user_games.running.map { |e| e }
    # True if there is running game.
    @running = current_user && current_user.user_games.running.any?
    # If the game running or paused read UserGame.
    user_game = current_user && current_user.user_games.find_by(game_id: @game.id, finished_at: nil)
    @show_timer = !user_game.nil?
    if @show_timer
      # Time when the game should stop.
      @stop_at = (user_game.started_at + user_game.game.time_length.minutes).httpdate
      @paused_at = user_game.paused_at
    end
  end

  # POST /games/:game_id/start
  def start
    user_game = !current_user.nil? && current_user.user_games.paused.find_by(game_id: params[:game_id])
    if !user_game && !current_user.user_games.running.any?
      game = Game.find params[:game_id]
      user_game = UserGame.new(user_id: current_user.id, game_id: game.id)
      user_game.started_at = params[:start_at]
      user_game.save
      redirect_to game_steps_flow_url(game)
      # render json: {
      #   stop_at: user_game.started_at + game.time_length.to_i.minutes
      # }
    else
      head :ok
    end
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
    head :ok
  end

  # GET /games/:game_is/steps_flow(/:step_id)
  def steps_flow
    @game = Game.find params[:game_id]
    if params[:step_id]
      @step = @game.game_steps.not_answered.find params[:step_id]
      @step = @game.game_steps.not_answered.last unless @step
    else
      @step = @game.game_steps.not_answered.first
    end
  end

  def new
    @game = Game.new
  end

  def edit
  end

  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:name, :description, :short_description, :status, :difficulty, :age_range,
                                    :time_length, :instructions,
                                    game_steps_attributes: [:id, :name, :description, :game_id, :_destroy,
                                      hints_attributes: [:id, :description, :value, :game_step_id, :_destroy],
                                      game_step_solutions_attributes: [:id, :solution, :game_step_id, :_destroy],
                                    ]
                                    )
    end

    def filter_params
      params.require(:filter).permit(:difficulty, :age_range).select { |_k, v| !v.blank? }
    end
end
