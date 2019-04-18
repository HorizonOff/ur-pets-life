module AdminPanel
  class PetsController < AdminPanelController
    before_action :authorize_super_admin_employee, only: :index
    before_action :set_pet, except: :index

    def index
      respond_to do |format|
        format.html {}
        format.xlsx { export_data }
        format.json { filter_pets }
      end
    end

    def edit; end

    def show
      @pet = ::AdminPanel::PetDecorator.decorate(@pet)
      @appointments = ::AdminPanel::AppointmentDecorator.decorate_collection(@pet.appointments
                                                                                 .includes(:bookable, :vet))
    end

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

    def filter_pets
      filtered_pets = filter_and_pagination_query.filter
      pets = ::AdminPanel::PetDecorator.decorate_collection(filtered_pets)
      serialized_pets = ActiveModel::Serializer::CollectionSerializer.new(
        pets, serializer: ::AdminPanel::PetFilterSerializer, adapter: :attributes
      )

      render json: { draw: params[:draw], recordsTotal: Pet.count,
                     recordsFiltered: filtered_pets.total_count, data: serialized_pets }
    end

    def filter_and_pagination_query
      @filter_and_pagination_query ||= ::AdminPanel::FilterAndPaginationQuery.new('Pet', params)
    end

    def export_data
      @pets = Pet.all.order(:id).includes(:user, :pet_type)
      @pets = ::AdminPanel::PetDecorator.decorate_collection(@pets)

      name = "pets #{Time.now.utc.strftime('%d-%M-%Y')}.xlsx"
      response.headers['Content-Disposition'] = "attachment; filename*=UTF-8''#{name}"
    end
  end
end
