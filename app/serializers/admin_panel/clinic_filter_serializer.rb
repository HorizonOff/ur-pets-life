module AdminPanel
  class ClinicFilterSerializer < BaseMethodsSerializer
    attributes :id, :name, :picture, :email, :mobile_number, :vets_count, :actions
    attribute :status, key: :is_active
  end
end
