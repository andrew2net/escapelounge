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

  def show
    @show_button = !(current_user && current_user.game_id)
    @show_timer = current_user && current_user.game_id && current_user.game_id == @game.id
    if @show_timer
      @stop_at = (current_user.game_start_at + current_user.game.time_length.minutes).httpdate
    end
  end

  def start
    if current_user && current_user.game_id.nil?
      game = Game.find params[:game_id]
      current_user.game = game
      current_user.game_start_at = params[:start_at]
      # relative time offset in minutes
      current_user.timezone_offset = params[:timezone_offset].to_i + Time.zone.utc_offset / 60
      current_user.save
      render json: {
        stop_at: current_user.game_start_at + (game.time_length - current_user.timezone_offset).minutes
      }
    else
      render json: { started: false }
    end
  end

  def pause
    if current_user && !current_user.game_id.nil?
      current_user.update pause_at: params[:seconds_remain]
    end
    head :ok
  end

  def resume
    if current_user && !current_user.pause_at.nil?
      passed_seconds = current_user.game.time_length * 60 - current_user.pause_at
      start_at = DateTime.parse(params[:start_at]) - passed_seconds.seconds
      current_user.update game_start_at: start_at, pause_at: nil
    end
    head :ok
  end

  def step
    @game = Game.find params[:game_id]
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
      params.require(:game).permit(:name, :description, :short_description, :status, :difficulty, :age_range, :time_length,
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
