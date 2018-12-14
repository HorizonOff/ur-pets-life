module AdminPanel
  class ItemBrandsController < AdminPanelController
  before_action :authorize_super_admin, only: :index
  before_action :set_admin_panel_item_brand, only: [:show, :edit, :update, :destroy]

  # GET /admin_panel/item_brands
  # GET /admin_panel/item_brands.json
  def index
    respond_to do |format|
      format.html {}
      format.json { filter_brands }
    end
  end

  # GET /admin_panel/item_brands/1
  # GET /admin_panel/item_brands/1.json
  def show
  end

  # GET /admin_panel/item_brands/new
  def new
    @admin_panel_item_brand = ItemBrand.new
  end

  # GET /admin_panel/item_brands/1/edit
  def edit
    @discountonbrand = @admin_panel_item_brand.brand_discount
  end

  # POST /admin_panel/item_brands
  # POST /admin_panel/item_brands.json
  def create
    @admin_panel_item_brand = ItemBrand.new(brand_params)
    if @admin_panel_item_brand.save
      flash[:success] = 'Item Brand was successfully created'
      redirect_to admin_panel_item_brands_path
    else
      render :new
    end
  end

  # PATCH/PUT /admin_panel/item_brands/1
  # PATCH/PUT /admin_panel/item_brands/1.json
  def update
    updateddiscount = 0.0

    if params[:item_brand][:brand_discount].blank?
      updateddiscount = 0.0
      params[:item_brand][:brand_discount] = 0.0
    else
      updateddiscount = params[:item_brand][:brand_discount].to_f
    end

    if (updateddiscount != @discountonbrand)
      branditems = Item.where(:item_brand_id => @admin_panel_item_brand.id)
      branditems.each do |item|
        updateditemprice = 0.0
        if updateddiscount <= 0.0
          updateditemprice = item.unit_price
        else
          updateditemprice = item.unit_price - ((updateddiscount * item.unit_price) / 100)
        end
        item.update(:price => updateditemprice, :discount => updateddiscount)
      end
    end

    if @admin_panel_item_brand.update(brand_params)
      flash[:success] = 'Item Brand was successfully updated'
      redirect_to admin_panel_item_brands_path
    else
      render :edit
    end
  end

  # DELETE /admin_panel/item_brands/1
  # DELETE /admin_panel/item_brands/1.json
  def destroy
    @admin_panel_item_brand.destroy
    respond_to do |format|
      format.html { redirect_to admin_panel_item_brands_url, notice: 'Item brand was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_panel_item_brand
      @admin_panel_item_brand = ItemBrand.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def brand_params
      params.require(:item_brand).permit(:name, :picture, :brand_discount, item_category_ids: [])
    end

    def filter_brands
      filtered_brands = filter_and_pagination_query.filter
      decorated_data = ::AdminPanel::ItemBrandDecorator.decorate_collection(filtered_brands)
      serialized_data = ActiveModel::Serializer::CollectionSerializer.new(
        decorated_data, serializer: ::AdminPanel::ItemBrandSerializer, adapter: :attributes
      )

      render json: { draw: params[:draw], recordsTotal: filtered_brands.count,
                     recordsFiltered: filtered_brands.total_count, data: serialized_data }
    end

    def filter_and_pagination_query
      @filter_and_pagination_query ||= ::AdminPanel::FilterAndPaginationQuery.new('ItemBrand', params)
    end

end
end
