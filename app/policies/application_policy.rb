class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def super_admin?
    user.is_super_admin?
  end

  def employee_or_super_admin?
    if user.is_super_admin?
      true
    elsif user.is_employee?
      true
    else
      false
    end
  end

  def msh_admin?
    if user.is_msh_admin?
      true
    else
      false
    end
  end

  def employee_or_super_admin_or_msh_admin?
    if user.is_super_admin?
      true
    elsif user.is_employee?
      true
    elsif user.is_msh_admin?
      true
    else
      false
    end
  end

  def cataloger_or_employee_or_super_admin?
    if user.is_super_admin?
      true
    elsif user.is_employee?
      true
    elsif user.is_cataloger?
      true
    else
      false
    end
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      if user.is_super_admin? || user.is_employee?
        scope.all
      elsif user.is_msh_admin?
        scope.msh_members
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
