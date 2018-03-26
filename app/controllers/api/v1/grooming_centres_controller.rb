module Api
  module V1
    class GroomingCentresController < Api::BaseController
      skip_before_action :authenticate_user, except: %i[schedule services]
      before_action :set_grooming_centre, except: :index
      before_action :parse_date, only: :schedule
      before_action :retrieve_pets_and_pet_types, only: :services

      def index
        grooming_centres = grooming_centres_query.find_objects
        serialized_centres = ActiveModel::Serializer::CollectionSerializer.new(
          grooming_centres, serializer: GroomingCentreIndexSerializer, scope: serializable_params
        )

        render json: { grooming_centres: serialized_centres, total_count: grooming_centres.total_count }
      end

      def show
        favorite = @grooming_centre.favorites.find_by(user: @user)
        @services = @grooming_centre.service_details.includes(:service_type)
                                    .group_by { |sd| [sd.service_type_id, sd.pet_type_id] }.values

        render json: @grooming_centre,
               scope: serializable_params.merge(favorite: favorite,
                                                service_types: service_type_serializer_service.serialize)
      end

      def schedule
        time_slots = schedule_parser_service.retrieve_time_slots

        render json: { time_slots: time_slots }
      end

      def services
        @services = @grooming_centre.service_details.with_pet_types(@pet_type_ids).includes(:service_type)
                                    .group_by { |sd| [sd.service_type_id, sd.pet_type_id] }

        render json: { pets: pet_services_serializer_service.serialize }
      end

      private

      def retrieve_pets_and_pet_types
        @pets = @user.pets.owned.where(id: params[:pet_ids])
        @pet_type_ids = @pets.pluck(:pet_type_id).uniq
      end

      def set_grooming_centre
        @grooming_centre = GroomingCentre.find_by_id(params[:id])
        return render_404 unless @grooming_centre
      end

      def grooming_centres_query
        @grooming_centres_query ||= ::Api::V1::LocationBasedQuery.new('GroomingCentre', params)
      end

      def schedule_parser_service
        @schedule_parser_service ||= ::Api::V1::ScheduleParserService.new(@grooming_centre, @date)
      end

      def service_type_serializer_service
        @service_type_serializer_service ||= ::Api::V1::ServiceTypeSerializerService.new(@services)
      end

      def pet_services_serializer_service
        @pet_services_serializer_service ||= ::Api::V1::PetServicesSerializerService.new(@services, @pets)
      end

      def parse_date
        @date = Time.zone.at(params[:date].to_i)
        return render_422(date: 'Date is required') if params[:date].blank? || @date.blank?
      end
    end
  end
end
