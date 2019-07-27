module Api
  module V1
    class DayCareCentresController < Api::BaseController
      skip_before_action :authenticate_user, except: %i[schedule services]
      before_action :set_day_care_centre, except: :index
      before_action :parse_date, only: :schedule
      before_action :retrieve_pets_and_pet_types, only: :services

      def index
        day_care_centres = day_care_centres_query.find_objects
        if @user&.is_msh_member?
          day_care_centres = day_care_centres.select { |center| center[:name].match(/My Second Home/).present? }
        end
        serialized_centres = ActiveModel::Serializer::CollectionSerializer.new(
          day_care_centres, serializer: DayCareCentreIndexSerializer, scope: serializable_params
        )

        render json: { day_care_centres: serialized_centres,
                       total_count: @user&.is_msh_member? ? day_care_centres.count : day_care_centres.total_count }
      end

      def show
        favorite = @day_care_centre.favorites.find_by(user: @user)
        @services = @day_care_centre.service_details.includes(:service_type)
                                    .group_by { |sd| [sd.service_type_id, sd.pet_type_id] }.values

        render json: @day_care_centre,
               include: 'service_option_details,service_option_details.service_option_times,pictures',
               scope: serializable_params.merge(favorite: favorite,
                                                service_types: service_type_serializer_service.serialize)
      end

      def schedule
        render json: { time_slots: schedule_day_parser_service.retrieve_time_slots }
      end

      def services
        @services = @day_care_centre.service_details.with_pet_types(@pet_type_ids).includes(:service_type)
                                    .group_by { |sd| [sd.service_type_id, sd.pet_type_id] }
        render json: { pets: pet_services_serializer_service.serialize }
      end

      private

      def retrieve_pets_and_pet_types
        @pets = @user.pets.owned.where(id: params[:pet_ids])
        @pet_type_ids = @pets.pluck(:pet_type_id).uniq
      end

      def set_day_care_centre
        @day_care_centre = DayCareCentre.find_by_id(params[:id])
        return render_404 unless @day_care_centre
      end

      def day_care_centres_query
        @day_care_centres_query ||= ::Api::V1::LocationBasedQuery.new('DayCareCentre', params)
      end

      def service_type_serializer_service
        @service_type_serializer_service ||= ::Api::V1::ServiceTypeSerializerService.new(@services)
      end

      def pet_services_serializer_service
        @pet_services_serializer_service ||= ::Api::V1::PetServicesSerializerService.new(@services, @pets, true)
      end

      def schedule_day_parser_service
        @schedule_day_parser_service ||= ::Api::V1::ScheduleDayParserService.new(@day_care_centre.schedule, @date)
      end

      def parse_date
        @date = Time.zone.at(params[:date].to_i)
        return render_422(date: 'Date is required') if params[:date].blank? || @date.blank?
      end
    end
  end
end
