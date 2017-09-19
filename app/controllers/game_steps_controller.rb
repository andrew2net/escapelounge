class GameStepsController < ApplicationController
  before_action :set_game_step, only: [:show, :edit, :update, :destroy]

  def index
    @game_steps = GameStep.all
  end

  def show
  end

  def new
    @game_step = GameStep.new
  end

  def edit
  end

  def create
    @game_step = GameStep.new(game_step_params)

    respond_to do |format|
      if @game_step.save
        format.html { redirect_to @game_step, notice: 'Game step was successfully created.' }
        format.json { render :show, status: :created, location: @game_step }
      else
        format.html { render :new }
        format.json { render json: @game_step.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @game_step.update(game_step_params)
        format.html { redirect_to @game_step, notice: 'Game step was successfully updated.' }
        format.json { render :show, status: :ok, location: @game_step }
      else
        format.html { render :edit }
        format.json { render json: @game_step.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @game_step.destroy
    respond_to do |format|
      format.html { redirect_to game_steps_url, notice: 'Game step was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_step
      @game_step = GameStep.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_step_params
      params.require(:game_step).permit(:name, :description, :game_id,
                                        hints_attributes: [:id, :description, :value, :game_step_id, :_destroy],
                                        game_step_solutions_attributes: [:id, :solution, :game_step_id, :_destroy])
    end
end
