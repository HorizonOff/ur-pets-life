module Api
  module V1
    class PetServicesSerializerService
      def initialize(services, pets, check_weight = false)
        @services = services
        @pets = pets
        @check_weight = check_weight

        self.serialized_pets = []
      end

      def serialize
        pets.each do |pet|
          serialized_pet = { name: pet.name, pet_id: pet.id }
          serialized_pet[:service_types] = service_type_serializer_service(pet).serialize
          serialized_pets << serialized_pet
        end
        serialized_pets
      end

      private

      def service_type_serializer_service(pet)
        if check_weight
          ::Api::V1::ServiceTypeSerializerService.new(services_for(pet), pet)
        else
          ::Api::V1::ServiceTypeSerializerService.new(services_for(pet))
        end
      end

      def services_for(pet)
        services.select { |k, _v| k.last == pet.pet_type_id }.values
      end

      attr_accessor :serialized_pets
      attr_reader :services, :pets, :check_weight
    end
  end
end
