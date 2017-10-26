class GamesHistoryController < ApplicationController
  def index
    @user_games = current_user.user_games.includes(:game).order(finished_at: :desc).page params[:page]
  end
end
