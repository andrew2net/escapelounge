# frozen_string_literal: true

# User model.
class User < ApplicationRecord
  before_destroy :unsubscribe

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_games, dependent: :destroy
  has_many :games, through: :user_games
  belongs_to :subscription_plan

  def last_active
    ug = user_games.order(:updated_at).last
    if ug && ug.updated_at > updated_at
      ug.updated_at
    else
      updated_at
    end
  end

  private

  def unsubscribe
    Stripe.api_key = ENV['STRIPE_API_KEY']
    if subscription_id && period_end && period_end > Time.now
      sub = Stripe::Subscription.retrieve(subscription_id)
      sub.delete
    end
    return unless stripe_id
    Stripe::Customer.retrieve(stripe_id).delete
  end
end
