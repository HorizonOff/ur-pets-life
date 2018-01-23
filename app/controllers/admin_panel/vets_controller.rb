module AdminPanel
  class VetsController < AdminPanelController
    before_action :set_vet, except: %i[index new create]
    before_action :set_location, only: %i[edit]

    def index
      @vets = Vet.all
    end

    def new
      @vet = Vet.new
      set_location
      @vet.qualifications.build
    end

    def edit; end

    def show; end

    def create
      @vet = Vet.new(vet_params)
      if @vet.save
        flash[:success] = 'Vet was successfully created'
        redirect_to admin_panel_vets_path
      else
        set_location
        render :new
      end
    end

    def update
      @vet.assign_attributes(vet_params)
      if @vet.save
        flash[:success] = 'Vet was successfully updated'
        redirect_to admin_panel_vets_path
      else
        set_location
        render :edit
      end
    end

    def destroy
      @vet.destroy
      flash[:success] = 'Vet was successfully deleted'
      redirect_to admin_panel_vets_path
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

    def set_location
      @vet.build_location if @vet.location.blank?
    end

    def vet_params
      params.require(:vet).permit(:name, :email, :avatar, :mobile_number, :consultation_fee, :experience, :is_active,
                                  :is_emergency, :use_clinic_location, :clinic_id,
                                  specialization_ids: [], pet_type_ids: [], qualifications_attributes:
                                  qualifications_params, location_attributes: location_params)
    end

    def qualifications_params
      %i[id diploma university _destroy]
    end

    def location_params
      %i[id latitude longitude city area street building_type building_name unit_number villa_number comment _destroy]
    end

    def parse_date
      @date = Time.zone.parse(params[:date])
      return render_422(date: 'Date is required') if params[:date].blank? || @date.blank?
    end

    def schedule_parser_service
      @schedule_parser_service ||= ::Api::V1::VetScheduleParserService.new(@vet, @date, true)
    end
  end
end
