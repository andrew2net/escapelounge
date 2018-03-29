class StepAnswer < ApplicationRecord
  # belongs_to :game_step
  belongs_to :game_step_solution
  belongs_to :user_game

  validates :game_step_solution_id, uniqueness: { scope: :user_game_id }
end
