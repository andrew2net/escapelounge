class GameStepSolution < ApplicationRecord
  belongs_to :game_step
  has_many :step_answers, dependent: :delete_all

  default_scope { order :game_step_id, :position }

  def self.check_answer(id, value)
    solution = find id
    solutions = solution.solution.downcase.split(";").map(&:strip)
    solutions.include? value.downcase.strip
  end
end
