# frozen_string_literal: true

# Subscription plan model
class SubscriptionPlan < ApplicationRecord
  before_create :create_stripe_product
  before_update :update_stripe_product

  validates :name, presence: true
  validates :stripe_id, presence: true, uniqueness: true
  validates :price, presence: true
  validates :period, presence: true

  has_many :users
  has_and_belongs_to_many :grades

  enum period: [:month]

  private

  def create_stripe_product
    Stripe.api_key = ENV['STRIPE_API_KEY']
    Stripe::Plan.create(
      amount: (price * 100).to_i,
      interval: period,
      product: { name: name },
      currency: 'usd',
      id: stripe_id
    )
  end

  def update_stripe_product
    return unless name_changed?
    Stripe.api_key = ENV['STRIPE_API_KEY']
    plan = Stripe::Plan.retrieve stripe_id
    product = Stripe::Product.retrieve plan.product
    product.name = name
    product.save
  end
end
