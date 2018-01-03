module AdminPanel
  class VetsController < AdminPanelController
    before_action :set_vet, only: %i[edit update destroy]
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

    def create
      @vet = Vet.new(vet_params)
      check_location
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
      check_location
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

    def check_location
      return @vet.location.destroy unless @vet.is_emergency
      return unless @vet.use_clinic_location?
      location = @vet.clinic.location.attributes.except('id', 'place_type', 'place_id', 'created_at',
                                                        'updated_at', 'comment')
      @vet.location.assign_attributes(location)
    end
  end
end
