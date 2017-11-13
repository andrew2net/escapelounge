class CreateGameAssets < ActiveRecord::Migration[5.1]
  def change
    create_table :game_assets do |t|
      t.string :name
      t.references :game, foreign_key: true

      t.timestamps
    end
    reversible do |dir|
      dir.up do
        add_attachment :game_assets, :file
      end
      dir.down do
        remove_attachment :game_assets, :file
      end
    end
  end
end
