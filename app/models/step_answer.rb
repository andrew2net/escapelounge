class StepAnswer < ApplicationRecord
  belongs_to :game_step
  belongs_to :user_game

  scope :of_user, -> (user_id) { joins(:user_game).where(user_games: { user_id: user_id }) }
end
