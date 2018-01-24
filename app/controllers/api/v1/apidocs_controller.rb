module Api
  module V1
    class ApidocsController < ActionController::Base
      include Swagger::Blocks

      swagger_root do
        key :swagger, '2.0'

        info do
          key :version, '1.0.0'
          key :title, 'Pets Life API'
        end

        security_definition :api_key do
          key :type, :apiKey
          key :name, 'Authorization'
          key :in, :header
        end

        key :host, ENV['ORIGINAL_URL'] || 'localhost:3000'
        key :basePath, '/api/v1'
        key :consumes, %w[application/json multipart/form-data]
        key :produces, %w[application/json multipart/form-data]
      end
      # A list of all classes that have swagger_* declarations.
      SWAGGERED_CLASSES = [
        Api::V1::Users,
        Api::V1::Passwords,
        Api::V1::Sessions,
        Api::V1::Pets,
        Api::V1::Breeds,
        Api::V1::VaccineTypes,
        Api::V1::Emergencies,
        Api::V1::Clinics,
        Api::V1::GroomingCentres,
        Api::V1::DayCareCentres,
        Api::V1::Trainers,
        Api::V1::Vets,
        Api::V1::Weights,
        Api::V1::Adoptions,
        Api::V1::LostAndFounds,
        Api::V1::Appointments,
        Api::V1::Favorites,
        Api::V1::Schedules,
        Api::V1::PetTypes,
        self
      ].freeze

      def index
        render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
      end
    end
  end
end
