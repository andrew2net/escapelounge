class RemoveScoreFromGame < ActiveRecord::Migration[5.1]
  def change
    remove_column :games, :score
  end
end
