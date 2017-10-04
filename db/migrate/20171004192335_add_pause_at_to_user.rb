class AddPauseAtToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :pause_at, :integer
    add_column :users, :timezone_offset, :integer, default: 0
  end
end
