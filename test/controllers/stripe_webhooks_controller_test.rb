require "test_helper"

class StripeWebhooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :two
  end

  test "should receive invoice.payment_succeeded event" do
    post stripe_webhooks_url, params: file_data("invoice.payment_succeeded.json"),
      headers: { 'Content-Type' => 'application/json' }
    assert_response :success
    @user.reload
    assert_not_nil @user.plan_id
    assert_not_nil @user.period_end
  end
end
