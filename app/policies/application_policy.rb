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
        scope.constantize.all
      else
        scope.constantize.where(clinic_id: user.clinic.try(:id))
      end
    end
  end
end
