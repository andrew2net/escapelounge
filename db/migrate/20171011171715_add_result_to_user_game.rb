class AddResultToUserGame < ActiveRecord::Migration[5.1]
  def change
    add_column :user_games, :result, :integer
  end
end
