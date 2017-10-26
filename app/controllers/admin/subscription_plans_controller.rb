class Admin::SubscriptionPlansController < ApplicationController
  before_action :set_subscription_plan, only: [:edit, :update, :destroy]

  # GET /admin/subscription_plans
  def index
    authorize SubscriptionPlan
    @subscription_plans = SubscriptionPlan.all
  end

  # GET /admin/subscription_plans/new
  def new
    authorize SubscriptionPlan
    @subscription_plan = SubscriptionPlan.new
  end

  # POST /admin/subscription_plans
  def create
    authorize SubscriptionPlan
    @subscription_plan = SubscriptionPlan.new subscription_plan_params
    respond_to do |format|
      if @subscription_plan.save
        format.html { redirect_to admin_subscription_plans_path, notice: "Subscription plan was successfully created."}
      else
        format.html { render :edit }
      end
    end
  end

  # GET /admin/subscription_plans/:id/edit
  def edit
    authorize @subscription_plan
  end

  # PATCH/PUT /admin/subscription_plans/:id
  def update
    authorize @subscription_plan
    respond_to do |format|
      if @subscription_plan.update subscription_plan_params
        format.html { redirect_to admin_subscription_plans_path, notice: "Subscription plan was successfully updated."}
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /admin/subscription_plans/:id
  def destroy
    authorize @subscription_plan
    @subscription_plan.destroy
    respond_to do |format|
      format.html { redirect_to admin_subscription_plans_path, notice: "Subscription plan was successfully destroyed."}
    end
  end

  private

  def subscription_plan_params
    params.require(:subscription_plan).permit(:name, :stripe_id, :period, :price, grade_ids: [])
  end

  def set_subscription_plan
    @subscription_plan = SubscriptionPlan.find params[:id]
  end
end