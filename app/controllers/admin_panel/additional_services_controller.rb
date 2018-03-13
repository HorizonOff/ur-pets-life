module AdminPanel
  class AdditionalServicesController < AdminPanelController
    before_action :set_additional_service, except: %i[index new create]
    before_action :authorize_super_admin

    def index
      authorize_super_admin
      respond_to do |format|
        format.html {}
        format.json { filter_additional_services }
      end
    end

    def new
      @additional_service = AdditionalService.new
      @additional_service.build_location
    end

    def edit; end

    def create
      @additional_service = AdditionalService.new(additional_service_params)
      if @additional_service.save
        flash[:success] = 'Additional Service was successfully created'
        redirect_to admin_panel_additional_services_path
      else
        render :new
      end
    end

    def update
      if @additional_service.update(additional_service_params)
        flash[:success] = 'Additional Service was successfully updated'
        redirect_to admin_panel_additional_services_path
      else
        render :edit
      end
    end

    def destroy
      if @additional_service.destroy
        respond_to do |format|
          format.json { render json: { message: 'Additional Service was deleted' } }
        end
      else
        respond_to do |format|
          format.json { render json: { errors: @additional_service.errors.full_messages }, status: 422 }
        end
      end
    end

    private

    def set_additional_service
      @additional_service = AdditionalService.find_by(id: params[:id])
    end

    def additional_service_params
      params.require(:additional_service).permit(:name, :email, :mobile_number, :website, :description, :picture,
                                                 :picture_cache, location_attributes: location_params)
    end

    def filter_additional_services
      filtered_additional_services = filter_and_pagination_query.filter
      additional_services = ::AdminPanel::AdditionalServiceDecorator.decorate_collection(filtered_additional_services)
      serialized_additional_services = ActiveModel::Serializer::CollectionSerializer.new(
        additional_services, serializer: ::AdminPanel::AdditionalServiceFilterSerializer, adapter: :attributes
      )

      render json: { draw: params[:draw], recordsTotal: AdditionalService.count,
                     recordsFiltered: filtered_additional_services.total_count, data: serialized_additional_services }
    end

    def filter_and_pagination_query
      @filter_and_pagination_query ||= ::AdminPanel::FilterAndPaginationQuery.new('AdditionalService', params)
    end
  end
end
