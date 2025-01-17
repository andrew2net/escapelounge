# frozen_string_literal: true

# User controller.
class Admin::UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  # GET /admin/users
  # GET /admin/users.json
  def index
    authorize User
    @users = User.includes(:subscription_plan).page params[:page]
  end

  # GET /admin/users/1
  # GET /admin/users/1.json
  def show
    authorize @user
    @user_games = @user.user_games.includes(:game).order(finished_at: :desc)
                       .page params[:page]
  end

  # GET /admin/users/new
  def new
    authorize User
    @user = User.new
  end

  # GET /admin/users/1/edit
  def edit
    authorize @user
  end

  # POST /admin/users
  # POST /admin/users.json
  def create
    authorize User
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html do
          redirect_to admin_user_url(@user),
                      notice: 'User was successfully created.'
        end
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    authorize @user
    respond_to do |format|
      if @user.update(user_params)
        format.html do
          redirect_to admin_user_url(@user),
                      notice: 'User was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    authorize @user
    @user.destroy
    respond_to do |format|
      format.html do
        redirect_to admin_users_url, notice: 'User was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list
  # through.
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation, :admin)
  end
end
