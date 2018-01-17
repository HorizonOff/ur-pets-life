module AdminPanel
  class DayCareCentresController < AdminPanelController
    before_action :set_day_care_centre, except: %i[index new create]
    def index
      @day_care_centres = DayCareCentre.all
    end

    def new
      @day_care_centre = DayCareCentre.new
      @day_care_centre.build_location
      @day_care_centre.build_schedule
    end

    def edit; end

    def show; end

    def create
      @day_care_centre = DayCareCentre.new(day_care_centre_params)
      if @day_care_centre.save
        flash[:success] = 'DayCare Centre was successfully created'
        redirect_to admin_panel_day_care_centres_path
      else
        render :new
      end
    end

    def update
      if @day_care_centre.update(day_care_centre_params)
        flash[:success] = 'DayCare Centre was successfully updated'
        redirect_to admin_panel_day_care_centres_path
      else
        render :edit
      end
    end

    def destroy
      @day_care_centre.destroy
      flash[:success] = 'DayCare Centre was successfully deleted'
      redirect_to admin_panel_day_care_centres_path
    end

    def new_service_type
      @service_type = @day_care_centre.service_types.new
      @service_details = @service_type.default_set
      render 'admin_panel/service_types/new'
    end

    private

    def set_day_care_centre
      @day_care_centre = DayCareCentre.find_by(id: params[:id])
    end

    def day_care_centre_params
      params.require(:day_care_centre).permit(:name, :email, :picture, :mobile_number, :website, :description,
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
