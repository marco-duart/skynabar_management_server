class StockMovementPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.manager?
        scope.all
      else
        scope.none
      end
    end
  end

  def index?
    user.manager?
  end

  def show?
    user.manager?
  end
end
