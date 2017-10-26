class Admin::GradesController < ApplicationController
  before_action :set_grade, only: [:show, :edit, :update, :destroy]

  # GET /admin/grades
  # GET /admin/grades.json
  def index
    @grades = Grade.all
  end

  # GET /admin/grades/1
  # GET /admin/grades/1.json
  def show
  end

  # GET /admin/grades/new
  def new
    @grade = Grade.new
  end

  # GET /admin/grades/1/edit
  def edit
  end

  # POST /admin/grades
  # POST /admin/grades.json
  def create
    @grade = Grade.new(grade_params)

    respond_to do |format|
      if @grade.save
        format.html { redirect_to admin_grades_path, notice: 'Grade was successfully created.' }
        format.json { render :show, status: :created, location: @grade }
      else
        format.html { render :new }
        format.json { render json: @grade.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/grades/1
  # PATCH/PUT /admin/grades/1.json
  def update
    respond_to do |format|
      if @grade.update(grade_params)
        format.html { redirect_to admin_grades_path, notice: 'Grade was successfully updated.' }
        format.json { render :show, status: :ok, location: @grade }
      else
        format.html { render :edit }
        format.json { render json: @grade.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/grades/1
  # DELETE /admin/grades/1.json
  def destroy
    @grade.destroy
    respond_to do |format|
      format.html { redirect_to admin_grades_url, notice: 'Grade was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grade
      @grade = Grade.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def grade_params
      params.require(:grade).permit(:name)
    end
end
