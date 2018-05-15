class AddSoundsToGame < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up do
        add_attachment :games, :success_sound
        add_attachment :games, :fail_sound
        add_attachment :games, :hint_sound
      end
      dir.down do
        remove_attachment :games, :success_sound
        remove_attachment :games, :fail_sound
        remove_attachment :games, :hint_sound
      end
    end
  end
end
