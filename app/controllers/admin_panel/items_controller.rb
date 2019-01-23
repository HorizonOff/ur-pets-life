module AdminPanel
  class ItemsController < AdminPanelController
    before_action :authorize_super_admin_employee, only: :index
    before_action :set_admin_panel_item, only: [:show, :edit, :update, :destroy]

  # GET /admin_panel/items
  # GET /admin_panel/items.json
  def index
    respond_to do |format|
      format.html {}
      format.json { filter_items }
    end
  end

  # GET /admin_panel/items/1
  # GET /admin_panel/items/1.json
  def show

  end

  # GET /admin_panel/items/new
  def new
    @admin_panel_item = Item.new
  end

  # GET /admin_panel/items/1/edit
  def edit
  end

  # POST /admin_panel/items
  # POST /admin_panel/items.json
  def create

    @admin_panel_item = Item.new(item_params)
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

  # PATCH/PUT /admin_panel/items/1
  # PATCH/PUT /admin_panel/items/1.json
  def update

    if (!params[:item][:discount].nil? and params[:item][:discount].to_i > 0)
      params[:item][:price] = params[:item][:unit_price].to_f - ((params[:item][:unit_price].to_f / 100) * params[:item][:discount].to_f)
    else
      params[:item][:discount] = 0
      params[:item][:price] = params[:item][:unit_price]
    end
    if @admin_panel_item.update(item_params)
      flash[:success] = 'Item was successfully updated'
      redirect_to admin_panel_item_path(@admin_panel_item)
    else
      render :edit
    end
  end

  # DELETE /admin_panel/items/1
  # DELETE /admin_panel/items/1.json
  def destroy
    @admin_panel_item.update_attribute(:is_active, false)
    respond_to do |format|
      format.html { redirect_to admin_panel_items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_panel_item
      @admin_panel_item = Item.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:name, :buying_price, :unit_price, :discount, :weight, :unit, :quantity, :pet_type_id, :price,
                                  :item_categories_id, :item_brand_id, :short_description, :description, :picture, :avatar_cache)
    end

    def filter_items
      filtered_items = filter_and_pagination_query.filter
      filtered_items = filtered_items.where(:is_active => true)
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

end
end
