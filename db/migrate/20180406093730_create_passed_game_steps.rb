class CreatePassedGameSteps < ActiveRecord::Migration[5.1]
  def change
    create_table :passed_game_steps do |t|
      t.references :user_game, foreign_key: true, on_delete: :cascade
      t.references :game_step, foreign_key: true, on_delete: :cascade

      t.timestamps
    end

    add_index :passed_game_steps, [:user_game_id, :game_step_id], unique: true

    reversible do |dir|
      dir.up do
        Game.all.each do |game|
          prew_position = 0
          game.game_steps.each do |step|
            step.position = prew_position + 1 unless step.position
            prew_position = step.position
          end
          game.user_games.each do |user_game|
            game.game_steps.each do |step|
              if !step.game_step_solutions.any? ||
                step.game_step_solutions.joins(:step_answer).where(step_answers: { user_game_id: user_game.id })
                PassedGameStep.create user_game: user_game, game_step: step
              end
            end
          end
        end
      end
    end
  end
end
