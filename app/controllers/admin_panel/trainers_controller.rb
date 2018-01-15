module AdminPanel
  class TrainersController < AdminPanelController
    before_action :set_trainer, except: %i[index new create]
    def index
      @trainers = Trainer.all
    end

    def new
      @trainer = Trainer.new
      @trainer.build_location
    end

    def edit; end

    def show; end

    def create
      @trainer = Trainer.new(trainer_params)
      if @trainer.save
        flash[:success] = 'Trainer was successfully created'
        redirect_to admin_panel_trainers_path
      else
        render :new
      end
    end

    def update
      if @trainer.update(trainer_params)
        flash[:success] = 'Trainer was successfully updated'
        redirect_to admin_panel_trainers_path
      else
        render :edit
      end
    end

    def destroy
      @trainer.destroy
      flash[:success] = 'Trainer was successfully deleted'
      redirect_to admin_panel_trainers_path
    end

    private

    def set_trainer
      @trainer = Trainer.find_by(id: params[:id])
    end

    def trainer_params
      params.require(:day_care_centre).permit(:name, :email, :picture, :mobile_number, :experience,
                                              pet_type_ids: [], location_attributes: location_params)
    end

    def location_params
      %i[latitude longitude city area street building_type building_name unit_number villa_number comment]
    end
  end
end
