class ServiceCentrePolicy < ApplicationPolicy
  def update?
    super_admin? || owner?
  end
end
