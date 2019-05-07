module AdminPanel
  class ItemsController < AdminPanelController
    before_action :authorize_super_admin_employee, only: :index
    before_action :set_admin_panel_item, only: [:show, :edit, :update, :hide, :destroy]

    def index
      respond_to do |format|
        format.html {}
        format.xlsx { export_data }
        format.json { filter_items }
      end
    end

    def show; end

    def new
      @admin_panel_item = Item.new
    end

    def edit; end

    def create
      @admin_panel_item = Item.new(item_params.merge({ expiry_at: params[:item][:expiry_at].to_date}))
      if (!@admin_panel_item.discount.nil? and @admin_panel_item.discount > 0)
        @admin_panel_item.price = @admin_panel_item.unit_price.to_f - (@admin_panel_item.unit_price.to_f / 100 * @admin_panel_item.discount.to_f).to_f
      else
        item_brand = ItemBrand.where(:id => @admin_panel_item.item_brand_id).first
        if (!item_brand.brand_discount.nil? and item_brand.brand_discount > 0)
          @admin_panel_item.price = @admin_panel_item.unit_price.to_f - ((@admin_panel_item.unit_price.to_f / 100) * item_brand.brand_discount).to_f
          @admin_panel_item.discount = item_brand.brand_discount
        else
          @admin_panel_item.price = @admin_panel_item.unit_price
          @admin_panel_item.discount = 0
        end
      end
      @admin_panel_item.avg_rating = 0
      @admin_panel_item.rating = 0
      @admin_panel_item.review_count = 0
      if @admin_panel_item.save
        flash[:success] = 'Product was successfully created'
        redirect_to admin_panel_items_path
      else
        render :new
      end
    end

    def update
      if (!params[:item][:discount].nil? and params[:item][:discount].to_i > 0)
        params[:item][:price] = params[:item][:unit_price].to_f - ((params[:item][:unit_price].to_f / 100) * params[:item][:discount].to_f)
      else
        params[:item][:discount] = 0
        params[:item][:price] = params[:item][:unit_price]
      end
      if @admin_panel_item.update(item_params.merge({ expiry_at: params[:item][:expiry_at].to_date}))
        flash[:success] = 'Item was successfully updated'
        redirect_to admin_panel_item_path(@admin_panel_item)
      else
        render :edit
      end
    end

    def hide
      if @admin_panel_item.is_active?
        @admin_panel_item.update_attribute(:is_active, false)
        flash[:success] = 'Item was hid'
      else
        @admin_panel_item.update_attribute(:is_active, true)
        flash[:success] = 'Item was unhid'
      end
      redirect_back(fallback_location: root_path)
    end

    def destroy
      any_item_relitions? ? @admin_panel_item.really_destroy! : @admin_panel_item.destroy
      respond_to do |format|
        format.html { redirect_to admin_panel_items_url, notice: 'Item was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private

    def any_item_relitions?
      @admin_panel_item.wishlists.blank? && @admin_panel_item.order_items.blank? &&
        @admin_panel_item.item_reviews.blank?
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_panel_item
      @admin_panel_item = Item.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:name, :buying_price, :unit_price, :discount, :weight, :unit, :quantity,
                                   :pet_type_id, :price, :item_categories_id, :item_brand_id, :short_description,
                                   :description, :picture, :avatar_cache, :expiry_at)
    end

    def filter_items
      filtered_items = filter_and_pagination_query.filter
      # filtered_items = filtered_items.where(:is_active => true)
      decorated_data = ::AdminPanel::ItemDecorator.decorate_collection(filtered_items)
      serialized_data = ActiveModel::Serializer::CollectionSerializer.new(
        decorated_data, serializer: ::AdminPanel::ItemSerializer, adapter: :attributes
      )

      render json: { draw: params[:draw], recordsTotal: filtered_items.count,
                     recordsFiltered: filtered_items.total_count, data: serialized_data }
    end

    def filter_and_pagination_query
      @filter_and_pagination_query ||= ::AdminPanel::FilterAndPaginationQuery.new('Item', params)
    end

    def export_data
      @items = Item.where(is_active: true).order(:id).includes(:item_brand)
      name = "Catalog #{Time.now.utc.strftime('%d-%M-%Y')}.xlsx"
      response.headers['Content-Disposition'] = "attachment; filename*=UTF-8''#{name}"
    end
  end
end
