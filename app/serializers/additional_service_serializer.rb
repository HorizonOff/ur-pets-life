class AdditionalServiceSerializer < BaseMethodsSerializer
  type 'additional_service'

  attributes :id, :name, :picture_url, :address, :distance, :website, :email, :mobile_number, :favorite_id
end
