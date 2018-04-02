class AddPositionToGameStepSolution < ActiveRecord::Migration[5.1]
  def change
    add_column :game_step_solutions, :position, :integer
  end
end
