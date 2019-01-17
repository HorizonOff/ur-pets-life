class AppointmentPolicy < ApplicationPolicy
  class Scope < Scope
  end

  def can_manage?
    super_admin? || owner?
  end
end
 
