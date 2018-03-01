module Api
  module V1
    class ServiceTypeSerializerService
      def initialize(services, pet = nil)
        @services = services
        @pet = pet

        self.serialized_services = []
      end

      def serialize
        if pet.present?
          check_weight_and_serialize
        else
          serialize_all
        end
      end

      private

      def serialize_all(pet_services = services)
        pet_services.each do |s|
          service_type = { id: s.first.service_type_id, name: s.first.name,
                           description: s.first.description, pet_type_id: s.first.pet_type_id }
          service_type[:service_details] = ActiveModel::Serializer::CollectionSerializer.new(
            s, serializer: ServiceDetailSerializer
          )
          serialized_services << service_type
        end
        serialized_services
      end

      def check_weight_and_serialize
        pet_services = []
        services.each do |service_type|
          checked_service_details = service_type.select { |sd| sd.weight.to_f > pet.weight }
          if checked_service_details.present?
            checked_service_detail = checked_service_details.sort_by { |i| i[:weight] }.first
          end
          pet_services << [checked_service_detail] if checked_service_detail
        end
        serialize_all(pet_services)
      end

      attr_accessor :serialized_services
      attr_reader :services, :pet
    end
  end
end
