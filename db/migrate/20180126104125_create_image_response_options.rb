class CreateImageResponseOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :image_response_options do |t|
      t.references :game_step, foreign_key: true, null: false

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        add_attachment :image_response_options, :image
      end
      dir.down do
        remove_attachment :image_response_options, :image
      end
    end
  end
end
