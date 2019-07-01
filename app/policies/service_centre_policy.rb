class ServiceCentrePolicy < ApplicationPolicy
  def update?
    super_admin? || owner? || (msh_admin? && record.name.match(/My Second Home/).present?)
  end
end
