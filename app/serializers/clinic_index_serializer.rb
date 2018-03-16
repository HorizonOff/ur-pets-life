class ClinicIndexSerializer < ServiceCentreIndexSerializer
  attribute :consultation_fee

  def consultation_fee
    scope[:hide_fee] ? nil : object.consultation_fee
  end
end
