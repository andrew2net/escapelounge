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
  end

  def start

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
