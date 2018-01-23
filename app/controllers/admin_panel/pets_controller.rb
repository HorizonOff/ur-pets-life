module AdminPanel
  class PetsController < AdminPanelController
    before_action :set_pet
    # before_action :set_location, only: %i[edit]

    def edit; end

    def show; end

    def update
      @pet.assign_attributes(pet_params)
      if @pet.save
        flash[:success] = 'Pet was successfully updated'
        redirect_to admin_panel_user_path(@pet.user)
      else
        set_location
        render :edit
      end
    end

    def destroy
      @pet.destroy
      flash[:success] = 'Pet was successfully deleted'
      redirect_to admin_panel_user_path(@pet.user)
    end

    def weight_history; end

    private

    def set_pet
      @pet = Pet.find_by(id: params[:id])
    end

    def set_location
      @pet.build_location if @pet.location.blank?
    end

    def pet_params
      params.require(:pet).permit(:name, :birthday, :breed_id, :weight, :avatar,
                                  :additional_type, :comment, location_attributes: location_params)
    end

    def location_params
      %i[id latitude longitude city area street building_type building_name unit_number villa_number comment _destroy]
    end
  end
end
