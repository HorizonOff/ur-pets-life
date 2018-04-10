module AdminPanel
  class ServiceTypesController < AdminPanelController
    before_action :set_service_type, except: :create
    before_action :set_service_details, only: :edit

    def edit; end

    def create
      @service_type = ServiceType.new(service_type_params)
      if @service_type.save
        redirect_to after_save_path
      else
        render :new
      end
    end

    def update
      if @service_type.update(service_type_params)
        redirect_to after_save_path
      else
        render :edit
      end
    end

    def destroy
      flash[:success] = 'Service was successfully deleted' if @service_type.destroy
    end

    private

    def set_service_type
      @service_type = ServiceType.find_by(id: params[:id])
    end

    def service_type_params
      params.require(:service_type).permit(:serviceable_type, :serviceable_id, :name, :description,
                                           service_details_attributes: %i[id pet_type_id min_weight weight
                                                                          total_space price _destroy],
                                           cat_services_attributes: service_params,
                                           dog_services_attributes: service_params,
                                           other_services_attributes: service_params)
    end

    def set_service_details
      @service_type.service_details_with_blanks
    end

    def service_params
      %i[id weight min_weight total_space price _destroy]
    end

    def after_save_path
      if @service_type.serviceable_type == 'DayCareCentre'
        admin_panel_day_care_centre_path(@service_type.serviceable_id)
      elsif @service_type.serviceable_type == 'Boarding'
        admin_panel_boarding_path(@service_type.serviceable_id)
      else
        admin_panel_grooming_centre_path(@service_type.serviceable_id)
      end
    end
  end
end
