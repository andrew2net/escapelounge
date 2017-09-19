class CreateGameStepSolutions < ActiveRecord::Migration[5.1]
  def change
    create_table :game_step_solutions do |t|
      t.references :game_step, foreign_key: true
      t.string :solution

      t.timestamps
    end
  end
end
