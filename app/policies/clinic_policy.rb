class ClinicPolicy < ServiceCentrePolicy
  def create?
    super_admin? || user.clinic.blank?
  end
end
