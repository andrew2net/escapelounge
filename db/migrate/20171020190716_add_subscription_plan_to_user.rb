class AddSubscriptionPlanToUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :plan_id
    add_reference :users, :subscription_plan, foreign_key: true
  end
end
