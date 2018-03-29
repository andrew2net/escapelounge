class GameStepSolution < ApplicationRecord
  belongs_to :game_step
  has_many :step_answers, dependent: :delete_all
end
