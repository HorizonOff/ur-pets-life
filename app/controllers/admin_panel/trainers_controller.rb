module AdminPanel
  class TrainersController < AdminPanelController
    before_action :authorize_super_admin
    before_action :set_trainer, except: %i[index new create]

    def index
      respond_to do |format|
        format.html {}
        format.json { filter_trainers }
      end
    end

    def new
      @trainer = Trainer.new
      @trainer.build_location
      @trainer.qualifications.build
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
      if @trainer.destroy
        render json: { message: 'Trainer was deleted' }, status: 200
      else
        render json: { errors: @trainer.errors.full_messages }, status: 422
      end
    end

    def new_service_type
      @service_type = @trainer.service_types.new
      @service_type.default_set
      render 'admin_panel/service_types/new'
    end

    private

    def set_trainer
      @trainer = Trainer.find_by(id: params[:id])
    end

    def trainer_params
      params.require(:trainer).permit(:name, :email, :picture, :mobile_number, :experience, :picture_cache,
                                      pet_type_ids: [], location_attributes: location_params, specialization_ids: [],
                                      qualifications_attributes: qualifications_params)
    end

    def filter_trainers
      filtered_trainers = filter_and_pagination_query.filter
      trainers = ::AdminPanel::TrainerDecorator.decorate_collection(filtered_trainers)
      serialized_trainers = ActiveModel::Serializer::CollectionSerializer.new(
        trainers, serializer: ::AdminPanel::TrainerFilterSerializer, adapter: :attributes
      )

      render json: { draw: params[:draw], recordsTotal: Trainer.count, recordsFiltered: filtered_trainers.total_count,
                     data: serialized_trainers }
    end

    def filter_and_pagination_query
      @filter_and_pagination_query ||= ::AdminPanel::FilterAndPaginationQuery.new('Trainer', params)
    end
  end
end
