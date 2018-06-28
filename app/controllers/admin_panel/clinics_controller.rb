module AdminPanel
  class ClinicsController < AdminPanelController
    include AdminPanel::ParamsHelper
    before_action :set_clinic, except: %i[index new create]
    before_action :can_create?, only: %i[new create]
    before_action :can_update?, except: %i[index new create]
    before_action :parse_params, only: %i[create update]

    def index
      authorize_super_admin
      respond_to do |format|
        format.html {}
        format.json { filter_clinics }
      end
    end

    def new
      @clinic = Clinic.new
      @clinic.build_location
      @clinic.build_schedule
    end

    def create
      @clinic = super_admin? ? Clinic.new(clinic_params) : current_admin.build_clinic(clinic_params)
      if @clinic.save
        flash[:success] = 'Clinic was successfully created'
        redirect_to admin_panel_clinic_path(@clinic)
      else
        render :new
      end
    end

    def show; end

    def edit; end

    def update
      if @clinic.update(clinic_params)
        flash[:success] = 'Clinic was successfully updated'
        redirect_to admin_panel_clinic_path(@clinic)
      else
        render :edit
      end
    end

    def destroy
      if @clinic.destroy
        respond_to do |format|
          format.html do
            flash[:success] = 'Clinic was deleted'
            redirect_to admin_panel_clinics_path
          end
          format.js { render json: { message: 'Clinic was deleted' } }
        end
      else
        respond_to do |format|
          format.html do
            flash[:error] = "Clinic wasn't deleted"
            render :show
          end
          format.js { render json: { errors: @clinic.errors.full_messages }, status: 422 }
        end
      end
    end

    def location
      render json: @clinic.location, adapter: :attributes
    end

    def add_vet
      @vet = @clinic.vets.new
      @vet.build_location
      @vet.qualifications.build
      render 'admin_panel/vets/new'
    end

    private

    def parse_params
      parse_params_for(:clinic)
    end

    def set_clinic
      @clinic = Clinic.find_by(id: params[:id])
    end

    def can_create?
      authorize :clinic, :create?
    end

    def can_update?
      authorize @clinic, :update?
    end

    def clinic_params
      params.require(:clinic).permit(:admin_id, :name, :email, :picture, :mobile_number, :consultation_fee, :website,
                                     :description, :is_emergency, :picture_cache,
                                     specialization_ids: [], pet_type_ids: [], location_attributes: location_params,
                                     schedule_attributes: schedule_params, pictures_attributes: picture_params)
    end

    def filter_clinics
      filtered_clinics = filter_and_pagination_query.filter
      clinics = ::AdminPanel::ClinicDecorator.decorate_collection(filtered_clinics)
      serialized_clinics = ActiveModel::Serializer::CollectionSerializer.new(
        clinics, serializer: ::AdminPanel::ClinicFilterSerializer, adapter: :attributes
      )
      render json: { draw: params[:draw], recordsTotal: Clinic.count, recordsFiltered: filtered_clinics.total_count,
                     data: serialized_clinics }
    end

    def filter_and_pagination_query
      @filter_and_pagination_query ||= ::AdminPanel::FilterAndPaginationQuery.new('Clinic', params)
    end
  end
end
