class CreateJoinTableHintsUserGames < ActiveRecord::Migration[5.1]
  def change
    create_join_table :hints, :user_games do |t|
      t.index :hint_id
      t.index :user_game_id
    end
  end
end
