class AddClueBackgroundToGameStep < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up do
        add_attachment :game_steps, :clue_background
      end
      dir.down do
        remove_attachment :game_steps, :clue_background
      end
    end
  end
end
