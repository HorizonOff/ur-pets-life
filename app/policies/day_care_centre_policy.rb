class DayCareCentrePolicy < ServiceCentrePolicy
  def create?
    super_admin? || user.day_care_centre.blank?
  end
end
