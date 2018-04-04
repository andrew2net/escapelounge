class AddPausesCountToUserGame < ActiveRecord::Migration[5.1]
  def change
    add_column :user_games, :pauses_count, :integer, default: 0
  end
end
