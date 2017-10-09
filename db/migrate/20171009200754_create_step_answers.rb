class CreateStepAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :step_answers do |t|
      t.references :game_step, foreign_key: true, null: false
      t.references :user_game, foreign_key: true, null: false

      t.timestamps
    end
  end
end
