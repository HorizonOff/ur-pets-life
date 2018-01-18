module AdminPanel
  class ServiceTypesController < AdminPanelController
    before_action :set_service_type, except: :create
    before_action :set_service_details, only: :edit

    def edit; end

    def create
      @service_type = ServiceType.new(service_type_params)
      flash[:success] = 'Service was successfully created' if @service_type.save
    end

    def update
      flash[:success] = 'Service was successfully updated' if @service_type.update(service_type_params)
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
                                           service_details_attributes: %i[id pet_type_id price _destroy])
    end

    def set_service_details
      @service_type.service_details_with_blanks
    end
  end
end
