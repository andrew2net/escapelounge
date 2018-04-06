class PassedGameStep < ApplicationRecord
  belongs_to :user_game
  belongs_to :game_step
end
