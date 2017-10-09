class RemoveValueFromGameStep < ActiveRecord::Migration[5.1]
  def change
    remove_column :game_steps, :value
  end
end
