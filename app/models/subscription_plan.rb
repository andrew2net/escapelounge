class SubscriptionPlan < ApplicationRecord
  has_many :users
  has_and_belongs_to_many :grades

  enum period: [:month]
end
