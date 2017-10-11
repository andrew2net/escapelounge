require "test_helper"

class UserGamesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user_game = user_games(:one)
    @user = users :one
  end

end
