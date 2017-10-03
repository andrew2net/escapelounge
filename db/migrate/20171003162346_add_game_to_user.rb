class AddGameToUser < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :game, foreign_key: true
    add_column :users, :game_start_at, :timestamp
  end
end
