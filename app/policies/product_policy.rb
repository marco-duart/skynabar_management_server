class ProductPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.manager?
  end

  def update?
    user.manager?
  end

  def shopping_list?
    user.manager?
  end

  def update_ideal_quantity?
    user.manager?
  end
end
