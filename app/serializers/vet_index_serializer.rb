class VetIndexSerializer < BaseMethodsSerializer
  attributes :id, :name, :avatar_url, :experience, :consultation_fee, :pet_type_ids, :favorite_id, :type
end
