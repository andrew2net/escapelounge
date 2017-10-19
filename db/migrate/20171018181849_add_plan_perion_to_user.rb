class AddPlanPerionToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :plan_id, :string
    add_column :users, :period_end, :timestamp
  end
end
