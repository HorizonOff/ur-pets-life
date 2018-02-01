module AdminPanel
  class ClinicsController < AdminPanelController
    before_action :set_clinic, except: %i[index new create]

    def index
      respond_to do |format|
        format.html {}
        format.json { filter_clinics }
      end
    end

    def new
      @clinic = Clinic.new
      @clinic.build_location
      @clinic.build_schedule
    end

    def create
      @clinic = Clinic.new(clinic_params)
      if @clinic.save
        flash[:success] = 'Clinic was successfully created'
        redirect_to admin_panel_clinics_path
      else
        render :new
      end
    end

    def show; end

    def edit; end

    def update
      if @clinic.update(clinic_params)
        flash[:success] = 'Clinic was successfully updated'
        redirect_to admin_panel_clinics_path
      else
        render :edit
      end
    end

    def destroy
      @clinic.destroy
      flash[:success] = 'Clinic was successfully deleted'
      redirect_to admin_panel_clinics_path
    end

    def location
      render json: @clinic.location, adapter: :attributes
    end

    def add_vet
      @vet = @clinic.vets.new
      @vet.build_location
      @vet.qualifications.build
      render 'admin_panel/vets/new'
    end

    private

    def set_clinic
      @clinic = Clinic.find_by(id: params[:id])
    end

    def clinic_params
      params.require(:clinic).permit(:name, :email, :picture, :mobile_number, :consultation_fee, :website, :description,
                                     :is_emergency, specialization_ids: [], pet_type_ids: [],
                                                    location_attributes: location_params,
                                                    schedule_attributes: schedule_params)
    end

    def location_params
      %i[latitude longitude city area street building_type building_name unit_number villa_number comment]
    end

    def schedule_params
      %i[day_and_night monday_open_at monday_close_at tuesday_open_at tuesday_close_at wednesday_open_at
         wednesday_close_at thursday_open_at thursday_close_at friday_open_at friday_close_at saturday_open_at
         saturday_close_at sunday_open_at sunday_close_at]
    end

    def filter_clinics
      filtered_clinics = filter_and_pagination_query.filter
      clinics = ClinicDecorator.decorate_collection(filtered_clinics)
      serialized_clinics = ActiveModel::Serializer::CollectionSerializer.new(
        clinics, serializer: ClinicFilterSerializer, adapter: :attributes
      )
      render json: { draw: params[:draw], recordsTotal: Clinic.count, recordsFiltered: filtered_clinics.total_count,
                     data: serialized_clinics }
    end

    def filter_and_pagination_query
      @filter_and_pagination_query ||= ::AdminPanel::FilterAndPaginationQuery.new('Clinic', params)
    end
  end
end
