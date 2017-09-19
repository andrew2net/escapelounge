class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.string :name
      t.string :description
      t.string :short_description
      t.integer :status
      t.integer :difficulty
      t.integer :age_range
      t.time :time_length
      t.boolean :visible, default: false

      t.timestamps
    end
  end
end
