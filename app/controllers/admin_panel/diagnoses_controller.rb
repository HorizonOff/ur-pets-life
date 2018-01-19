module AdminPanel
  class DiagnosesController < AdminPanelController
    before_action :set_appointment, only: %i[new create]
    before_action :set_diagnosis, only: %i[edit update]

    def new
      @diagnosis = @appointment.build_diagnosis
      @diagnosis.recipes.build
    end

    def create
      @diagnosis = @appointment.build_diagnosis(diagnosis_params)
      flash[:success] = 'Diagnosis wqas successfully created' if @diagnosis.save
    end

    def edit
      @diagnosis.recipes.build if @diagnosis.recipes.blank?
    end

    def update
      flash[:success] = 'Diagnosis was successfully updated' if @diagnosis.update(diagnosis_params)
    end

    private

    def diagnosis_params
      params.require(:diagnosis).permit(:condition, :message, recipes_attributes: %i[id instruction _destroy])
    end

    def set_appointment
      @appointment = Appointment.find_by(id: params[:appointment_id])
    end

    def set_diagnosis
      @diagnosis = Diagnosis.find_by(id: params[:id])
    end
  end
end
