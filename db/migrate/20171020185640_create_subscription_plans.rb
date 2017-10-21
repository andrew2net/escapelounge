class CreateSubscriptionPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :subscription_plans do |t|
      t.string :name
      t.string :stripe_id
      t.decimal :price, precision: 5, scale: 2
      t.integer :period, default: 0

      t.timestamps
    end
  end
end
