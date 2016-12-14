class CreateHints < ActiveRecord::Migration[5.0]
  def change
    create_table :hints do |t|
      t.string :description
      t.integer :game_step_id
      t.integer :value

      t.timestamps
    end
  end
end
