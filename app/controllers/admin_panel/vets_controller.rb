module AdminPanel
  class VetsController < AdminPanelController
    before_action :set_clinic, except: %i[index new create]
    def index
      @vets = Vet.all
    end

    def new
      @vet = Vet.new
      @vet.build_location
      @vet.qualification.build
    end

    def edit; end

    def create
      @vet = Vet.new(vat_params)
      if @vet.save
        flash[:success] = 'Vet was successfully created'
        redirect_to admin_panel_vets_path
      else
        render :new
      end
    end

    def update
      if @vet.update(vat_params)
        flash[:success] = 'Vet was successfully updated'
        redirect_to admin_panel_vets_path
      else
        render :edit
      end
    end

    def destroy
      @vet.destroy
      flash[:success] = 'Vet was successfully deleted'
      redirect_to admin_panel_vets_path
    end

    private

    def set_clinic
      @vet = Vet.find_by(id: params[:id])
    end

    def vat_params
      params.require(:vet).permit(:name, :email, :avatar, :mobile_number, :consultation_fee, :experience, :is_active,
                                  :is_emergency, specialization_ids: [], pet_type_ids: [],
                                                 qualifications_attributes: qualifications_params,
                                                 location_attributes: location_params)
    end

    def qualifications_params
      %i[id diploma university _destroy]
    end

    def location_params
      %i[latitude longitude city area street building_type building_name unit_number villa_number comment _destroy]
    end
  end
end
