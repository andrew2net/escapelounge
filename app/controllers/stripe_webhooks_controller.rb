class StripeWebhooksController < ActionController::Base

  # POST /stripe_webhooks
  def api
    Stripe.api_key = ENV["STRIPE_API_KEY"]
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = ENV["STRIPE_WH_SECRET"]
    payload = request.body.read
    event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)

    case event.type
    when "invoice.created"
    when "invoice.payment_succeeded"
      user = User.find_by stripe_id: event.data.object.customer
      if user
        subs = event.data.object.lines.data.first
        period_end = DateTime.strptime subs.period.end.to_s, "%s"
        plan = SubscriptionPlan.find_by stripe_id: subs.plan.id
        user.update subscription_plan: plan, period_end: period_end
      end
    when "invoice.payment_failed"
    when "charge.succeeded"
    when "charge.failed"
    when "customer.created"
    when "customer.deleted"
      user = User.find_by stripe_id: params.data.object.id
      user.update stripe_id: nil, subscription_plan_id: nil, period_end: nil if user
    when "customer.source.created"
    when "customer.subscription.created"
    when "customer.updated"
    end

    head :ok
  rescue JSON::ParserError
    # Invalid payload
    head :bad_request
  rescue Stripe::SignatureVerificationError
    # Invalid signature
    head :bad_request
  end
end
