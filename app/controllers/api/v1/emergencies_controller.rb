module Api
  module V1
    class EmergenciesController < Api::BaseController
      def index
        latitude = params[:latitude]
        longitude = params[:longitude]
        clinics = clinics_query.find_objects(latitude, longitude)
        vets = vets_query.find_objects(latitude, longitude)
        render json: clinics + vets, each_serializer: EmergencySerializer,
               scope: { latitude: latitude, longitude: longitude }
      end

      private

      def clinics_query
        @clinics_query ||= ::Api::V1::EmergenciesQuery.new(Clinic.where(is_emergency: true))
      end

      def vets_query
        @vets_query ||= ::Api::V1::EmergenciesQuery.new(Vet.where(is_emergency: true))
      end
    end
  end
end
