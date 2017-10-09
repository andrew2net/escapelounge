class StepAnswer < ApplicationRecord
  belongs_to :game_step
  belongs_to :user_game
end
