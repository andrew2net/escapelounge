class SubscriptionsController < ApplicationController
  before_action :set_api_key, only: [:subscribe_user, :billing, :add_card, :delete_card]

  # GET /subscriptions
  def index
  end

  # GET /subscriptions/:subscription_plan_id/subscribe
  def subscribe
  end

  # POST /subscriptions/:subscription_plan_id/subscribe
  def subscribe_user
    create_stripe_customer

    # TODO implemet change plan
    unless current_user.subscription_id
      subscription = Stripe::Subscription.create(
        customer: current_user.stripe_id,
        items: [{ plan: params[:subscription_plan_id] }]
      )
      current_user.update subscription_id: subscription.id
    end

    head :ok
  end

  # GET /subscriptions/billing
  def billing
    invoices = Stripe::Invoice.list customer: current_user.stripe_id
    @invoices = []
    invoices.auto_paging_each do |invoice|
      @invoices << {
        id:       invoice.id,
        created:  DateTime.strptime(invoice.date.to_s, "%s"),
        amount:   invoice.total.to_f / 100,
        currency: invoice.currency,
        status:   invoice.paid ? "paid" : "unpaid",
        lines:    invoice.lines.data.map { |l| {
          type:         l.type,
          name:         l.plan.name,
          amount:       l.amount.to_f / 100,
          period_start: DateTime.strptime(l.period.start.to_s, "%s"),
          period_end:   DateTime.strptime(l.period.end.to_s, "%s")
        }}
      }
    end

    cards = Stripe::Customer.retrieve(current_user.stripe_id).sources.all
    @cards = []
    cards.auto_paging_each { |card| @cards << card_data(card) }
  end

  def add_card
    stripe_customer = create_stripe_customer
    unless stripe_customer
      stripe_customer = Stripe::Customer.retrieve current_user.stripe_id
    end
    card = stripe_customer.sources.create source: params[:id]
    render 'card_data', card: card_data(card)
  end

  def delete_card
    customer = Stripe::Customer.retrieve(current_user.stripe_id)
    customer.sources.retrieve(params[:card_id]).delete
    head :ok
  end

  private

  def set_api_key
    Stripe.api_key = ENV["STRIPE_API_KEY"]
  end

  # Create and return Stripe customer. If customer already created then return nil.
  def create_stripe_customer
    unless current_user.stripe_id
      stripe_user = Stripe::Customer.create(
        email: current_user.email,
        source: params[:id]
      )
      current_user.update stripe_id: stripe_user.id
      stripe_user
    end
  end

  def card_data(card)
    {
      id:    card.id,
      brand: card.brand,
      exp:   "#{card.exp_month.to_s.rjust(2, "0")} / #{card.exp_year}",
      last4: "....#{card.last4}"
    }
  end
end
