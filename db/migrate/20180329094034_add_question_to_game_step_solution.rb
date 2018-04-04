class AddQuestionToGameStepSolution < ActiveRecord::Migration[5.1]
  def change
    add_column :game_step_solutions, :question, :string
  end
end
