require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @user = users :two
  end

  test "should unsubscribe and delete customer before delete" do
    @user.update period_end: (DateTime.now + 1.day), subscription_id: "sub_BbW7HRjhVh0EpK"
    subscription_mock, subscription_stub = stripe_subscription_retrive_mock
    customer_mock, customer_stub = stripe_customer_retrieve_mock
    Stripe::Customer.stub :retrieve, customer_stub do
      Stripe::Subscription.stub :retrieve, subscription_stub do
        @user.destroy
      end
    end
    assert_mock customer_mock
    assert_mock subscription_mock
  end

  private

  def stripe_subscription_retrive_mock
    subscription = Minitest::Mock.new
    subscription.expect :delete, {}
    retrieve_stub = lambda do |subscription_id|
      assert subscription_id.is_a? String
      subscription
    end
    [subscription, retrieve_stub]
  end

  def stripe_customer_retrieve_mock
    customer = Minitest::Mock.new
    customer.expect :delete, {}
    retrieve_stub = lambda do |customer_id|
      assert customer_id.is_a? String
      customer
    end
    [customer, retrieve_stub]
  end
end
