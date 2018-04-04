class ChangeGameStepRelationToGameStepSolutionForStepAnswer < ActiveRecord::Migration[5.1]
  def change
    add_reference :step_answers, :game_step_solution, foreign_key: true
    reversible do |dir|
      dir.up do
        StepAnswer.all.each do |sa|
          solution = sa.game_step.game_step_solutions.where('LOWER(solution) = ?', sa.answer).first
          sa.update game_step_solution: solution
        end
      end
    end
    remove_reference :step_answers, :game_step
  end
end
