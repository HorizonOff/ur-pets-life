module Api
  module V1
    class BoardingsController < Api::BaseController
      skip_before_action :authenticate_user, except: %i[schedule services]
      before_action :set_boarding, except: :index
      before_action :parse_date, only: :schedule
      before_action :retrieve_pets_and_pet_types, only: :services

      def index
        boardings = boardings_query.find_objects
        serialized_centres = ActiveModel::Serializer::CollectionSerializer.new(
          boardings, serializer: BoardingIndexSerializer, scope: serializable_params
        )

        render json: { boardings: serialized_centres, total_count: boardings.total_count }
      end

      def show
        favorite = @boarding.favorites.find_by(user: @user)
        @services = @boarding.service_details.includes(:service_type)
                             .group_by { |sd| [sd.service_type_id, sd.pet_type_id] }.values

        render json: @boarding,
               include: 'service_option_details,service_option_details.service_option_times,pictures',
               scope: serializable_params.merge(favorite: favorite,
                                                service_types: service_type_serializer_service.serialize)
      end

      def schedule
        render json: { time_slots: schedule_day_parser_service.retrieve_time_slots }
      end

      def services
        @services = @boarding.service_details.with_pet_types(@pet_type_ids).includes(:service_type)
                             .group_by { |sd| [sd.service_type_id, sd.pet_type_id] }

        render json: { pets: pet_services_serializer_service.serialize }
      end

      private

      def retrieve_pets_and_pet_types
        @pets = @user.pets.owned.where(id: params[:pet_ids])
        @pet_type_ids = @pets.pluck(:pet_type_id).uniq
      end

      def set_boarding
        @boarding = Boarding.find_by_id(params[:id])
        return render_404 unless @boarding
      end

      def boardings_query
        @boardings_query ||= ::Api::V1::LocationBasedQuery.new('Boarding', params)
      end

      def service_type_serializer_service
        @service_type_serializer_service ||= ::Api::V1::ServiceTypeSerializerService.new(@services)
      end

      def pet_services_serializer_service
        @pet_services_serializer_service ||= ::Api::V1::PetServicesSerializerService.new(@services, @pets, true)
      end

      def schedule_day_parser_service
        @schedule_day_parser_service ||= ::Api::V1::ScheduleDayParserService.new(@boarding.schedule, @date)
      end

      def parse_date
        @date = Time.zone.at(params[:date].to_i)
        return render_422(date: 'Date is required') if params[:date].blank? || @date.blank?
      end
    end
  end
end
