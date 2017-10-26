class GamesHistoryController < ApplicationController
  def index
    @user_games = current_user.user_games.includes(:game)
  end
end
