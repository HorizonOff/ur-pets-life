module AdminPanel
  class AdsController < AdminPanelController
    before_action :authorize_super_admin

    def index
      respond_to do |format|
        format.html {}
        format.json { filter_ads }
      end
    end

    def new
      @ad = Ad.new
    end

    def create
      @ad = Ad.new(ad_params)
      if @ad.save
        flash[:success] = 'Ad was successfully created'
        redirect_to admin_panel_ads_path
      else
        render :new
      end
    end

    def change_status
      @ad = Ad.find_by(id: params[:id])
      Ad.make_inactive unless @ad.is_active?
      @ad.is_active = !@ad.is_active
      if @ad.save
        flash[:success] = 'Ad status wascahnged'
      else
        flash[:error] = 'Some error'
      end
      redirect_to admin_panel_ads_path
    end

    private

    def ad_params
      params.require(:ad).permit(:name, :image, :is_active)
    end

    def filter_ads
      filtered_ads = filter_and_pagination_query.filter
      ads = ::AdminPanel::AdDecorator.decorate_collection(filtered_ads)
      serialized_ads = ActiveModel::Serializer::CollectionSerializer.new(
        ads, serializer: ::AdminPanel::AdFilterSerializer, adapter: :attributes
      )

      render json: { draw: params[:draw], recordsTotal: Ad.count,
                     recordsFiltered: filtered_ads.total_count, data: serialized_ads }
    end

    def filter_and_pagination_query
      @filter_and_pagination_query ||= ::AdminPanel::FilterAndPaginationQuery.new('Ad', params)
    end
  end
end
