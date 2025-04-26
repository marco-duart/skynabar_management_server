class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    user.manager?
  end

  def show?
    user.manager? || record.user == user
  end

  def create?
    user.manager?
  end

  def update?
    user.manager?
  end

  def destroy?
    user.manager?
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NoMethodError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end
end
