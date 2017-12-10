class SubscriptionsController < ApplicationController
  before_action :set_api_key, only: [
    :subscribe_user, :billing, :add_card, :delete_card, :set_default, :unsubscribe
  ]

  # GET /subscriptions
  def index
    redirect_to billing_subscriptions_path if current_user.subscription_id
    @subscription_plans = SubscriptionPlan.all
  end

  # GET /subscriptions/:subscription_plan_id/subscribe
  def subscribe
    redirect_to billing_subscriptions_path if current_user.subscription_id
  end

  # POST /subscriptions/:subscription_plan_id/subscribe
  def subscribe_user
    create_stripe_customer

    # Create or change subscription plan
    if !current_user.subscription_id
      plan = SubscriptionPlan.find params[:subscription_plan_id]
      subscription = Stripe::Subscription.create(
        customer: current_user.stripe_id,
        items: [{ plan: plan.stripe_id }]
      )
      current_user.update subscription_id: subscription.id, subscription_plan: plan,
        period_end: DateTime.strptime(subscription.current_period_end.to_s, "%s")
    elsif current_user.subscription_plan_id != params[:subscription_plan_id]
      plan = SubscriptionPlan.find params[:subscription_plan_id]
      subscription = Stripe::Subscription.retrieve current_user.subscription_id

      # If current subscription is canceled then create new else update current one
      if subscription.status == "canceled"
        subscription = Stripe::Subscription.create customer: current_user.stripe_id,
          items: [{ plan: plan.stripe_id }]
      else
        item_id = subscription.items.data[0].id
        subscription.items = [{ id: item_id, plan: plan.stripe_id }]
        subscription.save
      end

      current_user.update subscription_id: subscription.id, subscription_plan: plan,
        period_end: DateTime.strptime(subscription.current_period_end.to_s, "%s")
    end

    head :ok
  end

  # POST /subscriptions/unsubscribe
  def unsubscribe
    subscription = Stripe::Subscription.retrieve current_user.subscription_id
    subscription.delete at_period_end: true
    head :ok
  end

  # GET /subscriptions/billing
  def billing
    if current_user.stripe_id
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

      subscription = Stripe::Subscription.retrieve current_user.subscription_id
      @subscription_canceled = subscription.status == "canceled"
      @subscription_will_cancel = !@subscription_canceled && subscription.cancel_at_period_end
      stripe_customer = Stripe::Customer.retrieve(current_user.stripe_id)
      cards = stripe_customer.sources.all
      @cards = cards_data(cards: cards, default: stripe_customer.default_source)
    else
      redirect_to subscriptions_path
    end
  end

  # POST /subscriptions/billing
  def add_card
    stripe_customer = create_stripe_customer
    unless stripe_customer
      stripe_customer = Stripe::Customer.retrieve current_user.stripe_id
    end
    stripe_customer.sources.create source: params[:id]
    cards = stripe_customer.sources.all
    @cards = cards_data(cards: cards, default: stripe_customer.default_source)
    render partial: "cards"
  end

  # POST /subscriptions/delete_card
  def delete_card
    stripe_customer = Stripe::Customer.retrieve(current_user.stripe_id)
    stripe_customer.sources.retrieve(params[:card_id]).delete
    stripe_customer = Stripe::Customer.retrieve(current_user.stripe_id)
    cards = stripe_customer.sources.all
    @cards = cards_data(cards: cards, default: stripe_customer.default_source)
    render partial: "cards"
  end

  # POST /subscriptions/set_default
  def set_default
    stripe_customer = Stripe::Customer.retrieve(current_user.stripe_id)
    stripe_customer.default_source = params[:card_id]
    stripe_customer.save
    cards = Stripe::Customer.retrieve(current_user.stripe_id).sources.all
    @cards = cards_data(cards: cards, default: stripe_customer.default_source)
    render partial: "cards"
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

  # Retirn array of cards for view
  def cards_data(cards:, default:)
    crds= []
    cards.auto_paging_each do |card|
      crds << {
        id:    card.id,
        brand: card.brand,
        exp:   "#{card.exp_month.to_s.rjust(2, "0")} / #{card.exp_year}",
        last4: "....#{card.last4}",
        default: default == card.id ? 'default' : ''
      }
    end
    crds
  end
end
