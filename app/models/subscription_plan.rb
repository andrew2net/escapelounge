class SubscriptionPlan < ApplicationRecord
  has_many :users
  enum period: [:month]
end
