require 'test_helper'

class Admin::SubscriptionPlansControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @subscription_plan = subscription_plans :one
    @user = users :one
    sign_in @user
  end

  test "should get index" do
    get admin_subscription_plans_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_subscription_plan_path
    assert_response :success
  end

  test "should create subscription plan" do
    grade = grades :one
    assert_difference "SubscriptionPlan.count" do
      post admin_subscription_plans_path, params: { subscription_plan: {
        name:      "Test",
        stripe_id: "test",
        period:    "month",
        price:     19.99,
        grade_ids: [grade.id]
      }}
    end
    assert_redirected_to admin_subscription_plans_path
  end

  test "should get edit" do
    get edit_admin_subscription_plan_path @subscription_plan
    assert_response :success
  end

  test "should update subscription plan" do
    patch admin_subscription_plan_path @subscription_plan, params: {
      subscription_plan: { name: "New name" }
    }
    assert_redirected_to admin_subscription_plans_path
  end

  test "should destroy subscription plan" do
    assert_difference "SubscriptionPlan.count", -1 do
      delete admin_subscription_plan_path @subscription_plan
    end
    assert_redirected_to admin_subscription_plans_path
  end
end
