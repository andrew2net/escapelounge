class CreateGameSteps < ActiveRecord::Migration[5.0]
  def change
    create_table :game_steps do |t|
      t.string :name
      t.string :description
      t.integer :value
      t.integer :game_id

      t.timestamps
    end
  end
end
