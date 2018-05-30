class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def super_admin?
    user.is_super_admin?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      if user.is_super_admin?
        scope.all
      else
        scope.joins(:admin).where(admins: { id: user.id })
      end
    end
  end

  private

  def owner?
    record.admin_id == user.id
  end
end
