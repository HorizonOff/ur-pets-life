class GroomingCentrePolicy < ServiceCentrePolicy
  def create?
    super_admin? || user.grooming_centre.blank?
  end
end
