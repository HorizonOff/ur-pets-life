class ServiceOptionDetailAppointmentSerializer < ActiveModel::Serializer
  attributes :id, :service_option_id, :name, :price

  has_many :service_option_times do
    scope[:service_option_times].select { |sot| sot.service_option_detail_id == object.id }
  end
end
