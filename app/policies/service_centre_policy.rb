class ServiceCentrePolicy < ApplicationPolicy
  def update?
    super_admin? || owner?
  end

  private

  def owner?
    record.admin_id == user.id
  end
end
