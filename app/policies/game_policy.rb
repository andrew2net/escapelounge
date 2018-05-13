# frozen_string_literal: true

# Games access policies.
class GamePolicy < ApplicationPolicy
  def index?
    user&.admin?
  end

  def create?
    user&.admin?
  end

  def update?
    user&.admin?
  end

  def start?
    user.period_end && user.period_end > Time.now &&
      record.grades.joins(:subscription_plans)
            .where(subscription_plans: { id: user.subscription_plan_id }).any?
  end

  def destroy?
    user.admin?
  end
end
