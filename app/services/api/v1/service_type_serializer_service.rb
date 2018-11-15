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
        services.each do |st|
          checked_service_detail = check_services_weight(st)
          pet_services << [checked_service_detail] if checked_service_detail
        end
        serialize_all(pet_services)
      end

      def check_services_weight(service_type)
        service_type.select { |sd| sd.weight.to_f >= pet.weight && sd.min_weight.to_f <= pet.weight }.first
      end

      attr_accessor :serialized_services
      attr_reader :services, :pet
    end
  end
end
