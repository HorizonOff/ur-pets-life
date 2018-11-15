class VetPolicy < ApplicationPolicy
  class Scope < Scope
  end

  def create?
    super_admin? || user.clinic.present?
  end

  def update?
    super_admin? || owner?
  end

  private

  def owner?
    user.clinic.id == record.clinic_id
  end
end
