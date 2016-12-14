class HintsController < ApplicationController
  before_action :set_hint, only: [:show, :edit, :update, :destroy]

  # GET /hints
  # GET /hints.json
  def index
    @hints = Hint.all
  end

  # GET /hints/1
  # GET /hints/1.json
  def show
  end

  # GET /hints/new
  def new
    @hint = Hint.new
  end

  # GET /hints/1/edit
  def edit
  end

  # POST /hints
  # POST /hints.json
  def create
    @hint = Hint.new(hint_params)

    respond_to do |format|
      if @hint.save
        format.html { redirect_to @hint, notice: 'Hint was successfully created.' }
        format.json { render :show, status: :created, location: @hint }
      else
        format.html { render :new }
        format.json { render json: @hint.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hints/1
  # PATCH/PUT /hints/1.json
  def update
    respond_to do |format|
      if @hint.update(hint_params)
        format.html { redirect_to @hint, notice: 'Hint was successfully updated.' }
        format.json { render :show, status: :ok, location: @hint }
      else
        format.html { render :edit }
        format.json { render json: @hint.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hints/1
  # DELETE /hints/1.json
  def destroy
    @hint.destroy
    respond_to do |format|
      format.html { redirect_to hints_url, notice: 'Hint was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hint
      @hint = Hint.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hint_params
      params.require(:hint).permit(:description, :game_step_id, :value)
    end
end
