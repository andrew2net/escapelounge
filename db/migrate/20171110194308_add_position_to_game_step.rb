class AddPositionToGameStep < ActiveRecord::Migration[5.1]
  def change
    add_column :game_steps, :position, :integer
  end
end
