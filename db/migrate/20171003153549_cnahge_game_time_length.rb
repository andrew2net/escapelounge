class CnahgeGameTimeLength < ActiveRecord::Migration[5.1]
  def change
    remove_column :games, :time_length
    add_column :games, :time_length, :integer
  end
end
