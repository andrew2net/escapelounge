require "test_helper"

class StripeWebhooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :two
    ENV["STRIPE_API_KEY"] = ""
    ENV["STRIPE_WH_SECRET"] = ""
  end

  test "should receive invoice.payment_succeeded event" do
    t = DateTime.now.to_i.to_s
    pl = file_data("invoice.payment_succeeded.json")
    sp = "#{t}.#{pl}"
    dd = OpenSSL::Digest.new('sha256')
    sg = OpenSSL::HMAC.hexdigest(dd, ENV['STRIPE_WH_SECRET'], sp)
    sig = "t=#{t},v1=#{sg},v0=4122f6ad533c2ac9eadd677459ca265bdc9f74548ea0c645b18e37aa7de2a301"
    post stripe_webhooks_url, params: pl,
      headers: { 'Content-Type' => 'application/json', 'HTTP_STRIPE_SIGNATURE' => sig }
    assert_response :success
    @user.reload
    assert_not_nil @user.subscription_plan_id
    assert_not_nil @user.period_end
  end
end
