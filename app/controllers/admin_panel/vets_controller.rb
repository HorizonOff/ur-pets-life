module AdminPanel
  class VetsController < AdminPanelController
    before_action :set_vet, except: %i[index new create]
    before_action :set_location, only: %i[edit]
    before_action :can_create?, only: %i[index new create]
    before_action :can_update?, except: %i[index new create]

    def index
      respond_to do |format|
        format.html {}
        format.json { filter_vets }
      end
    end

    def new
      @vet = Vet.new
      set_location
      @vet.qualifications.build
    end

    def edit; end

    def show; end

    def create
      @vet = super_admin? ? Vet.new(vet_params) : current_admin.clinic.vets.build(vet_params)
      if @vet.save
        flash[:success] = 'Vet was successfully created'
        redirect_to admin_panel_vet_path(@vet)
      else
        set_location
        render :new
      end
    end

    def update
      @vet.assign_attributes(vet_params)
      if @vet.save
        flash[:success] = 'Vet was successfully updated'
        redirect_to admin_panel_vet_path(@vet)
      else
        set_location
        render :edit
      end
    end

    def destroy
      if @vet.destroy
        respond_to do |format|
          format.html do
            flash[:success] = 'Vet was deleted'
            redirect_to admin_panel_vets_path
          end
          format.js { render json: { message: 'Vet was deleted' } }
        end
      else
        respond_to do |format|
          format.html do
            flash[:error] = "Vet wasn't deleted"
            render :show
          end
          format.js { render json: { errors: @vet.errors.full_messages }, status: 422 }
        end
      end
    end

    def schedule
      parse_date
      time_slots = schedule_parser_service.retrieve_time_slots
      render json: { time_slots: time_slots }
    end

    private

    def set_vet
      @vet = Vet.find_by(id: params[:id])
    end

    def can_create?
      authorize :vet, :create?
    end

    def can_update?
      authorize @vet, :update?
    end

    def set_location
      @vet.build_location if @vet.location.blank?
    end

    def vet_params
      params.require(:vet).permit(:name, :email, :avatar, :mobile_number, :consultation_fee, :experience, :is_active,
                                  :is_emergency, :use_clinic_location, :clinic_id, :session_duration, :avatar_cache,
                                  specialization_ids: [], pet_type_ids: [], qualifications_attributes:
                                  qualifications_params, location_attributes: location_params)
    end 

    def parse_date
      @date = Time.zone.parse(params[:date])
      return render_422(date: 'Date is required') if params[:date].blank? || @date.blank?
    end

    def schedule_parser_service
      @schedule_parser_service ||= ::Api::V1::VetScheduleParserService.new(@vet, @date, for_cms?)
    end

    def for_cms?
      true
    end

    def filter_vets
      filtered_vets = filter_and_pagination_query.filter
      vets = ::AdminPanel::VetDecorator.decorate_collection(filtered_vets)
      serialized_vets = ActiveModel::Serializer::CollectionSerializer.new(
        vets, serializer: ::AdminPanel::VetFilterSerializer, adapter: :attributes
      )
      render json: { draw: params[:draw], recordsTotal: Vet.count, recordsFiltered: filtered_vets.total_count,
                     data: serialized_vets }
    end

    def filter_and_pagination_query
      @filter_and_pagination_query ||= ::AdminPanel::FilterAndPaginationQuery.new('Vet', params, current_admin)
    end
  end
end
