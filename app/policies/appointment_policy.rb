class AppointmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.is_super_admin?
        scope.constantize.all
      else
        user.appointments
      end
    end
  end

  def can_manage?
    super_admin? || owner?
  end
end
