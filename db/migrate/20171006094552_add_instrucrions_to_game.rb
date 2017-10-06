class AddInstrucrionsToGame < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :instructions, :text
    reversible do |dir|
      dir.up do
        add_attachment :games, :instructions_pdf
      end
      dir.down do
        remove_attachment :games, :instructions_pdf
      end
    end
  end
end
