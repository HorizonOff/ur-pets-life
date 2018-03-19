module AdminPanel
  class PetsController < AdminPanelController
    before_action :set_pet

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

    def vaccinations
      @vaccinations = @pet.vaccinations.includes(:vaccine_type).order(created_at: :asc)
    end

    def diagnoses
      @diagnoses = @pet.diagnoses.order(created_at: :asc)
    end

    private

    def set_pet
      @pet = Pet.find_by(id: params[:id])
    end

    def set_location
      @pet.build_location if @pet.location.blank?
    end

    def pet_params
      params.require(:pet).permit(:name, :birthday, :breed_id, :weight, :avatar, :avatar_cache, :additional_type,
                                  :lost_at, :found_at, :description, :mobile_number, :additional_comment,
                                  :comment, :municipality_tag, :microchip, location_attributes: location_params)
    end
  end
end
