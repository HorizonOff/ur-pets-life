module AdminPanel
  class GroomingCentresController < AdminPanelController
    include AdminPanel::PictureParamsHelper
    before_action :set_grooming_centre, except: %i[index new create]
    before_action :can_create?, only: %i[new create]
    before_action :can_update?, except: %i[index new create]

    def index
      respond_to do |format|
        format.html {}
        format.json { filter_grooming_centres }
      end
    end

    def new
      @grooming_centre = GroomingCentre.new
      @grooming_centre.build_relations
    end

    def edit
      @grooming_centre.build_relations
    end

    def show; end

    def create
      parse_picture_params(:grooming_centre)
      @grooming_centre = if super_admin?
                           GroomingCentre.new(grooming_centre_params)
                         else
                           current_admin.build_grooming_centre(grooming_centre_params)
                         end
      if @grooming_centre.save
        flash[:success] = 'Grooming Centre was successfully created'
        redirect_to admin_panel_grooming_centre_path(@grooming_centre)
      else
        @grooming_centre.build_relations
        render :new
      end
    end

    def update
      parse_picture_params(:grooming_centre)
      if @grooming_centre.update(grooming_centre_params)
        flash[:success] = 'Grooming Centre was successfully updated'
        redirect_to admin_panel_grooming_centres_path
      else
        @grooming_centre.build_relations
        render :edit
      end
    end

    def destroy
      if @grooming_centre.destroy
        respond_to do |format|
          format.html do
            flash[:success] = 'Grooming Centre was deleted'
            redirect_to admin_panel_grooming_centres_path
          end
          format.json { render json: { message: 'Grooming Centre was deleted' } }
        end
      else
        respond_to do |format|
          format.html do
            flash[:error] = "Grooming Centre wasn't deleted"
            render :show
          end
          format.json { render json: { errors: @grooming_centre.errors.full_messages }, status: 422 }
        end
      end
    end

    def new_service_type
      @service_type = @grooming_centre.service_types.new
      @service_type.default_set
      render 'admin_panel/service_types/new'
    end

    def calendar; end

    def timeline
      render json: @grooming_centre.blocked_times
                                   .where(start_at: Time.zone.parse(params[:start])..Time.zone.parse(params[:end])),
             each_serializer: AdminPanel::BlockedTimeSerializer, adapter: :attributes
    end

    def appointments
      appointments = @grooming_centre.appointments
                                     .where(status: params[:status].to_sym,
                                            start_at: Time.zone.parse(params[:start])..Time.zone.parse(params[:end]))
      render json: appointments, each_serializer: AdminPanel::AppointmentCalendarSerializer, adapter: :attributes
    end

    def lock_time
      blocked_time = @grooming_centre.blocked_times.new(calendar_params)
      if blocked_time.save
        render json: { id: blocked_time.id }
      else
        render json: { errors: blocked_time.errors.full_messages }, status: 422
      end
    end

    private

    def set_grooming_centre
      @grooming_centre = GroomingCentre.find_by(id: params[:id])
    end

    def can_create?
      authorize :grooming_centre, :create?
    end

    def can_update?
      authorize @grooming_centre, :update?
    end

    def grooming_centre_params
      params.require(:grooming_centre).permit(:admin_id, :name, :email, :picture, :mobile_number, :website,
                                              :description, :picture_cache,
                                              service_option_details_attributes: service_option_params,
                                              location_attributes: location_params,
                                              schedule_attributes: schedule_params,
                                              pictures_attributes: picture_params)
    end

    def filter_grooming_centres
      filtered_grooming_centres = filter_and_pagination_query.filter
      grooming_centres = ::AdminPanel::GroomingCentreDecorator.decorate_collection(filtered_grooming_centres)
      serialized_grooming_centres = ActiveModel::Serializer::CollectionSerializer.new(
        grooming_centres, serializer: ::AdminPanel::GroomingCentreFilterSerializer, adapter: :attributes
      )

      render json: { draw: params[:draw], recordsTotal: GroomingCentre.count,
                     recordsFiltered: filtered_grooming_centres.total_count, data: serialized_grooming_centres }
    end

    def filter_and_pagination_query
      @filter_and_pagination_query ||= ::AdminPanel::FilterAndPaginationQuery.new('GroomingCentre', params)
    end

    def calendar_params
      params.permit(:start_at, :end_at)
    end
  end
end
