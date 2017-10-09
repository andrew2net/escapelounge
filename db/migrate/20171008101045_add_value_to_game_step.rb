class AddValueToGameStep < ActiveRecord::Migration[5.1]
  def change
    add_column :game_steps, :value, :integer
  end
end
