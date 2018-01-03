module AdminPanel
  class GroomingCentresController < AdminPanelController
    before_action :set_grooming_centre, except: %i[index new create]
    def index
      @grooming_centres = GroomingCentre.all
    end

    def new
      @grooming_centre = GroomingCentre.new
      @grooming_centre.build_location
      @grooming_centre.build_schedule
    end

    def edit; end

    def create
      @grooming_centre = GroomingCentre.new(grooming_centre_params)
      if @grooming_centre.save
        flash[:success] = 'Grooming Centre was successfully created'
        redirect_to admin_panel_grooming_centres_path
      else
        render :new
      end
    end

    def update
      if @grooming_centre.update(grooming_centre_params)
        flash[:success] = 'Grooming Centre was successfully updated'
        redirect_to admin_panel_grooming_centres_path
      else
        render :edit
      end
    end

    def destroy
      @grooming_centre.destroy
      flash[:success] = 'Grooming Centre was successfully deleted'
      redirect_to admin_panel_grooming_centres_path
    end

    private

    def set_grooming_centre
      @grooming_centre = GroomingCentre.find_by(id: params[:id])
    end

    def grooming_centre_params
      params.require(:grooming_centre).permit(:name, :email, :picture, :mobile_number, :website, :description,
                                              service_option_ids: [], location_attributes: location_params,
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
  end
end
