class GamePolicy < ApplicationPolicy
  def update?
    user.admin?
  end
end
