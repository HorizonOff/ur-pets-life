class BoardingPolicy < ServiceCentrePolicy
  def create?
    super_admin? || user.boarding.blank?
  end
end
