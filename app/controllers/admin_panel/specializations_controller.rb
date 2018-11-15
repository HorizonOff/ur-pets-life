module AdminPanel
  class SpecializationsController < AdminPanelController
    before_action :authorize_super_admin
    before_action :set_specialization, only: %i[edit update destroy]

    def index
      respond_to do |format|
        format.html {}
        format.json { filter_specializations }
      end
    end

    def new
      @specialization = Specialization.new
    end

    def create
      @specialization = Specialization.new(specializations_params)
      if @specialization.save
        flash[:success] = 'Specialization was successfully created'
        redirect_to admin_panel_specializations_path
      else
        render :new
      end
    end

    def edit; end

    def update
      if @specialization.update(specializations_params)
        flash[:success] = 'Specialization was successfully updated'
        redirect_to admin_panel_specializations_path
      else
        render :edit
      end
    end

    def destroy
      if @specialization.destroy
        render json: { message: 'Specialization was deleted' }
      else
        render json: { errors: @specialization.errors.full_messages }, status: 422
      end
    end

    private

    def specializations_params
      params.require(:specialization).permit(:name, :is_for_trainer)
    end

    def set_specialization
      @specialization = Specialization.find_by(id: params[:id])
    end

    def filter_specializations
      filtered_specializations = filter_and_pagination_query.filter
      specializations = ::AdminPanel::SpecializationDecorator.decorate_collection(filtered_specializations)
      serialized_specializations = ActiveModel::Serializer::CollectionSerializer.new(
        specializations, serializer: ::AdminPanel::SpecializationFilterSerializer, adapter: :attributes
      )

      render json: { draw: params[:draw], recordsTotal: Specialization.count,
                     recordsFiltered: filtered_specializations.total_count, data: serialized_specializations }
    end

    def filter_and_pagination_query
      @filter_and_pagination_query ||= ::AdminPanel::FilterAndPaginationQuery.new('Specialization', params)
    end
  end
end
