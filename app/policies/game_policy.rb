class GamePolicy < ApplicationPolicy
  def index?
    user && user.admin?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  def start?
    record.grades.joins(:subscription_plans)
      .where(subscription_plans: {id: user.subscription_plan_id}).any?
  end

  def destroy?
    user.admin?
  end
end
