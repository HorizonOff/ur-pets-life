class TrainerSerializer < BaseMethodsSerializer
  type 'trainer'
  attributes :id, :name, :picture_url, :mobile_number, :pet_type_ids, :experience, :specializations, :address,
             :favorite_id

  has_many :qualifications

  has_many :service_types

  def specializations
    object.specializations.pluck(:name)
  end
end
