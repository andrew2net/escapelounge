class AddBannerToGame < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up do
        add_attachment :games, :banner
      end

      dir.down do
        remove_attachment :games, :banner
      end
    end
  end
end
