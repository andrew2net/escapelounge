class AddBackgroundToGame < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up do
        add_attachment :games, :background
      end

      dir.down do
        remove_attachment :games, :background
      end
    end
  end
end
