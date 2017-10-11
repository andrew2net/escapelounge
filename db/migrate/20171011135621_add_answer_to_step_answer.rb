class AddAnswerToStepAnswer < ActiveRecord::Migration[5.1]
  def change
    add_column :step_answers, :answer, :string
  end
end
