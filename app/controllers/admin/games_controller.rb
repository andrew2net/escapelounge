class Admin::GamesController < ApplicationController
  before_action :set_game, only: [:edit, :update, :destroy]

  # GET /admin/games
  def index
    authorize Game
    @games = Game.all
  end

  # GET /admin/games/new
  def new
    authorize Game
    @game = Game.new
  end

  # POST /admin/games
  def create
    authorize Game
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

  # GET /admin/games/:id/edit
  def edit
    authorize @game
  end

  # PATCH/PUT /admin/games/:id
  def update
    authorize @game
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

  # DELETE /admin/games/:id
  def destroy
    @game.destroy
    authorize @game
    respond_to do |format|
      format.html { redirect_to admin_games_url, notice: 'Game was successfully destroyed.' }
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
      params.require(:game).permit(:name, :description, :short_description, :status, :difficulty, {grade_ids: []},
                                    :time_length, :instructions, :banner, :background, :visible,
                                    game_assets_attributes: [:id, :name, :file, :_destroy],
                                    game_steps_attributes: [:id, :name, :description, :game_id, :_destroy, :position, :image,
                                      hints_attributes: [:id, :description, :value, :game_step_id, :_destroy, :image],
                                      game_step_solutions_attributes: [:id, :solution, :game_step_id, :_destroy],
                                    ]
                                    )
    end
end
