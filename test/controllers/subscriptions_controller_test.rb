require "test_helper"

class SubscriptionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users :two
    sign_in @user
  end

  test "should return subscriptions page" do
    get subscriptions_path
    assert_response :success
  end

  test "should rturn subscribe page" do
    get subscription_subscribe_path subscription_plans(:one)
    assert_response :success
  end

  test "should create Stripe's customer and subscription" do
    @user.update stripe_id: nil
    Stripe::Customer.stub :create, stripe_customer_mock do
      Stripe::Subscription.stub :create, stripe_subscription_mock do
        post subscription_subscribe_path subscription_plans(:one),
          params: { id: "tok_1BG4IkJt7tLdSPFUbrlvRggu" }
        assert_response :success
        @user.reload
        assert_equal "cus_BbW69wBIqWUgUs", @user.stripe_id
        assert_equal "sub_BbW7HRjhVh0EpK", @user.subscription_id
      end
    end
  end

  test "should update subscription" do
    @user.update subscription_id: "sub_BbW7HRjhVh0EpK"
    Stripe::Customer.stub :create, stripe_customer_mock do
      Stripe::Subscription.stub :create, stripe_subscription_mock do
        post subscription_subscribe_path subscription_plans(:one)
        assert_response :success
        @user.reload
        assert_equal DateTime.strptime(1511017428.to_s, "%s"), @user.period_end
      end
    end
  end

  test "should render billing page" do
    Stripe::Invoice.stub :list, stripe_invoice_list_mock do
      get billing_subscriptions_path
      assert_response :success
    end
  end

  test "should add card" do
    Stripe::Customer.stub :retrieve, stripe_customer_retrieve_mock do
      post billing_subscriptions_path, params: { id: "tok_1BG4IkJt7tLdSPFUbrlvRggu" }
      assert_response :success
      assert_includes "Visa", response.body
    end
  end

  test "should delete card" do
    Stripe::Customer.stub :retrieve, stripe_customer_retrieve_mock do
      post delete_card_subscriptions_path, params: { card_id: "card_1BFjKrJt7tLdSPFUNU5OKKHb" }
      assert_response :success
    end
  end

  test "should set default card" do
    Stripe::Customer.stub :retrieve, stripe_customer_retrieve_mock do
      post set_default_subscriptions_path, params: { card_id: "card_1BFjKrJt7tLdSPFUNU5OKKHb" }
      assert_response :success
    end
  end

  private

    def stripe_customer_mock
      customer = Minitest::Mock.new
      customer.expect :id, "cus_BbW69wBIqWUgUs"
      lambda { |email:, source:|
        assert_equal email, @user.email
        assert source.is_a? String
        customer
      }
    end

    def stripe_customer_retrieve_mock
      card = Minitest::Mock.new
      card.expect :id, "card_1BFjKrJt7tLdSPFUNU5OKKHb"
      card.expect :brand, "Visa"
      card.expect :exp_month, 8
      card.expect :exp_year, 2018
      card.expect :last4, "4242"
      card.expect :delete, nil

      cards = Minitest::Mock.new
      cards.expect :auto_paging_each, card

      sources = Minitest::Mock.new
      sources.expect :all, cards
      sources.expect :create, nil, [source: "tok_1BG4IkJt7tLdSPFUbrlvRggu"]
      sources.expect :retrieve, card, [String]

      customer = Minitest::Mock.new
      customer.expect :default_source, "card_1BF0qDJt7tLdSPFUyYY4nJLz"
      customer.expect :default_source=, nil, [String]
      customer.expect :save, nil
      customer.expect :sources, sources
      customer.expect :sources, sources
      lambda do |stripe_id|
        assert stripe_id.is_a? String
        customer
      end
    end

    def stripe_subscription_mock
      subscription = Minitest::Mock.new
      subscription.expect :id, "sub_BbW7HRjhVh0EpK"
      subscription.expect :current_period_end, 1511017428
      lambda do |customer:, items:|
        assert customer.is_a? String
        assert items.is_a? Array
        assert_not items.empty?
        subscription
      end
    end

    def stripe_invoice_list_mock
      plan = Minitest::Mock.new
      plan.expect :name, "Bse plan"

      subscription_period = Minitest::Mock.new
      subscription_period.expect :start, 1511017428
      subscription_period.expect :end, 1513609428

      invoice_line = Minitest::Mock.new
      invoice_line.expect :type, "subscription"
      invoice_line.expect :plan, plan
      invoice_line.expect :amount, 999
      invoice_line.expect :period, subscription_period
      invoice_line.expect :period, subscription_period

      invoice_lines = Minitest::Mock.new
      invoice_lines.expect :data, [invoice_line]

      invoice = Minitest::Mock.new
      invoice.expect :id, "in_1BEJ5EJt7tLdSPFU9dESDEGo"
      invoice.expect :date, 1508339028
      invoice.expect :total, 999
      invoice.expect :currency, "usd"
      invoice.expect :paid, true
      invoice.expect :lines, invoice_lines

      invoice_list = Minitest::Mock.new
      invoice_list.expect :invoice, invoice
      def invoice_list.auto_paging_each; yield(invoice); end
      invoice_list
    end
end
