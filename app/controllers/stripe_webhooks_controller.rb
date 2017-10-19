class StripeWebhooksController < ActionController::Base

  # POST /stripe_webhooks
  def api
    case params[:type]
    when "invoice.created"
    when "invoice.payment_succeeded"
      user = User.find_by stripe_id: params[:data][:object][:customer]
      if user
        subs = params[:data][:object][:lines][:data][0]
        period_end = DateTime.strptime subs[:period][:end].to_s, "%s"
        user.update plan_id: subs[:plan][:id], period_end: period_end
      end
    when "invoice.payment_failed"
    when "charge.succeeded"
    when "charge.failed"
    when "customer.created"
    when "customer.deleted"
      user = User.find_by stripe_id: params[:data][:object][:id]
      user.update stripe_id: nil if user
    when "customer.source.created"
    when "customer.subscription.created"
    when "customer.updated"
    end

    head :ok
  end
end
