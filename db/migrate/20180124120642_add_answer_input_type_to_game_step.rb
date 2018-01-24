class AddAnswerInputTypeToGameStep < ActiveRecord::Migration[5.1]
  def change
    add_column :game_steps, :answer_input_type, :integer, null: false, default: 0
  end
end
