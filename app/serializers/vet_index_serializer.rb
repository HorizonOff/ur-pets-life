class VetIndexSerializer < BaseMethodsSerializer
  attributes :id, :name, :avatar_url, :experience, :consultation_fee, :pet_type_ids, :favorite_id, :type, :picture_url

  def picture_url
    avatar_url if scope[:favorite].present?
  end
end
