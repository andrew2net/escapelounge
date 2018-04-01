class AddStartPopupToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :start_popup, :boolean, default: true
    reversible do |dir|
      dir.up do
        User.update_all start_popup: true
      end
    end
  end
end
