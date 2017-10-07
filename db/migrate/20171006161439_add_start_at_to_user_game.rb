class AddStartAtToUserGame < ActiveRecord::Migration[5.1]
  def change
    add_column :user_games, :started_at, :timestamp, null: false
    add_column :user_games, :paused_at, :integer
    add_column :user_games, :finished_at, :timestamp

    remove_column :users, :game_id, :bigint
    remove_column :users, :game_start_at, :timestamp
    remove_column :users, :pause_at, :integer
    remove_column :users, :timezone_offset, :integer
  end
end
