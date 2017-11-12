class AddImageToGameStep < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up do
        add_attachment :game_steps, :image
      end
      dir.down do
        remove_attachment :game_steps, :image
      end
    end
  end
end
