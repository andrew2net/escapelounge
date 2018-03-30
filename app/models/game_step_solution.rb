class GameStepSolution < ApplicationRecord
  belongs_to :game_step
  has_many :step_answers, dependent: :delete_all

  def self.check_answer(id, value)
    solution = find id
    solutions = solution.solution.downcase.split(";").map(&:strip)
    solutions.include? value.downcase.strip
  end
end
