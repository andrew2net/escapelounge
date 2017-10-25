class Grade < ApplicationRecord
  has_and_belongs_to_many :games
  has_and_belongs_to_many :subscription_plans
end
