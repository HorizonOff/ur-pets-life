module Api
  module V1
class ItemsController < Api::BaseController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  # GET /items
  # GET /items.json
  def index
    @items = Item.where(:is_active => true)
    if (!params[:pageno].nil? and !params[:size].nil?)
      size = params[:size].to_i
      page = params[:pageno].to_i
      @items = @items.limit(size).offset(page * size)
    end
    render json: @items
  end

  def quick_search_items
    return render_422('At least 3 characters in keyword') if params[:keyword].blank? || params[:keyword].length < 3

    @items = Item.active.where('items.name ILIKE :value', value: "%#{params[:keyword]}%").limit(40)
    @items = @items.sale if params[:sale_only].in?([true, 'true'])
    @items = @items.send(params[:category]) if params[:category].present?
    @brands = ItemBrand.where('item_brands.name ILIKE :value', value: "%#{params[:keyword]}%").limit(5)
    render json: { items: ActiveModel::Serializer::CollectionSerializer.new(@items, serializer: ItemSearchSerializer),
                   brands: ActiveModel::Serializer::CollectionSerializer.new(@brands,
                                                                             serializer: ItemBrandSerializer) }
  end

  def search_items_by_keywords
    if params[:lowerprice].nil? || params[:upperprice].nil? || params[:minrating].nil? || params[:maxrating].nil?
      return render json: {
        Message: 'Parameters not found',
        status: :unprocessable_entity
      }
    elsif params[:keyword].nil?
      if !params[:pageno].nil? && !params[:size].nil?
        size = params[:size].to_i
        page = params[:pageno].to_i

        @items = Item.where("price BETWEEN (?) AND  (?) AND avg_rating BETWEEN (?) AND (?)", params[:lowerprice], params[:upperprice], params[:minrating], params[:maxrating]).limit(size).offset(page * size)
      else
        @items = Item.where("price BETWEEN (?) AND  (?) AND avg_rating BETWEEN (?) AND (?)", params[:lowerprice], params[:upperprice], params[:minrating], params[:maxrating])
      end
    else
      key = "%#{params[:keyword]}%"
      if !params[:pageno].nil? && !params[:size].nil?
        size = params[:size].to_i
        page = params[:pageno].to_i

        @items = Item.where("(lower(items.name) LIKE (?)) AND price BETWEEN (?) AND  (?) AND avg_rating BETWEEN (?) AND (?)", key.downcase, params[:lowerprice], params[:upperprice], params[:minrating], params[:maxrating]).limit(size).offset(page * size)
      else
        @items = Item.where("(lower(items.name) LIKE (?)) AND price BETWEEN (?) AND  (?) AND avg_rating BETWEEN (?) AND (?)", key.downcase, params[:lowerprice], params[:upperprice], params[:minrating], params[:maxrating])
      end
    end
    @items = @items.left_outer_joins(:item_categories).where(item_categories: { id: params[:category_id] }).distinct if params[:category_id].present?
    @items = @items.left_outer_joins(:item_brand).where(item_brands: { id: params[:brand_id] }).distinct if params[:brand_id].present?
    @items = @items.left_outer_joins(:pet_types).where(pet_types: { id: params[:pet_type_id] }).distinct if params[:pet_type_id].present?
    sort_filter = params[:sortby].blank? ? 1 : params[:sortby].to_i
    if sort_filter == 1
      @items = @items.order(name: :asc)
    elsif sort_filter == 2
      @items = @items.order(name: :desc)
    elsif sort_filter == 3
      @items = @items.order(created_at: :desc)
    elsif sort_filter == 4
      @items = @items.order(created_at: :asc)
    end
    json_to_render = []
    @items = @items.active.includes(:wishlists)
    @items = @items.sale if params[:sale_only].in?([true, 'true'])
    @items = @items.send(params[:category]) if params[:category].present?
    if @items.nil? || @items.empty?
      render json: {
        Message: 'No Items found'
      }
    else
      @items.each do |myitem|
        json_to_render << ({
          :item => myitem.as_json(:only => [:id, :picture, :name, :price, :unit_price, :discount, :description, :weight, :unit, :rating, :review_count, :avg_rating, :quantity, :short_description]),
          :IsFavorite => get_wish_list_flag(myitem),
          :WishlistId => get_wish_list_id(myitem)
          }
        )
      end
      render :json => json_to_render
    end
  end

  def search_items_using_filters
    item_categories = []
    filter_from_pets_and_categories = ItemCategory.includes(:pet_types).where(item_categories: {id: params[:categories]}, pet_types: { id: params[:pets] }).each do |catg|
      item_categories << catg.id
    end
    item_brand_ids = []
    filter_from_categories_and_brands = ItemBrand.includes(:item_categories).where(item_brands: {id: params[:brands]}, item_categories: {id: item_categories}).each do |brand|
      item_brand_ids << brand.id
    end
    @items = Item.where("price >= (?) AND price <= (?) AND item_brand_id IN (?)", params[:lowerprice], params[:upperprice], item_brand_ids)
    @items = @items.active
    @items = @items.sale if params[:sale_only].in?([true, 'true'])
    if @items.nil? or @items.empty?
      format.json do
        render json: {
          Message: 'No Items found'
        }
      end
    else
    json_to_render = []
    @items.each do |myitem|
      json_to_render << ({
        :item => myitem.as_json(:only => [:id, :picture, :name, :price, :unit_price, :discount, :description, :weight, :unit, :rating, :review_count, :avg_rating, :quantity, :short_description]),
        :IsFavorite => get_wish_list_flag(myitem),
        :WishlistId => get_wish_list_id(myitem)
        }
      )
      end
    render json: json_to_render
  end
    #render json: item_brand_ids
  end

  def get_items_by_pet_type
    respond_to do |format|
    if PetType.where(:id => params[:id], :IsHaveCategories => false).exists?
    brand =  Item.left_outer_joins(:pet_types).where(pet_types: { id: params[:pet_type_id] }).order(id: :asc)
    json_to_render = []
    @items = brand.where(:is_active => true)
    if @items.nil? or @items.empty?
      format.json do
        render json: {
          Message: 'No Items found'
        }
      end
    else
    @items.each do |myitem|
      json_to_render << ({
        :item => myitem.as_json(:only => [:id, :picture, :name, :price, :unit_price, :discount, :description, :weight, :unit, :rating, :review_count, :avg_rating, :quantity, :short_description]),
        :IsFavorite => get_wish_list_flag(myitem),
        :WishlistId => get_wish_list_id(myitem)
        }
      )
      end
      format.json do
    render :json => json_to_render
  end
end
else
  format.json do
    render json: {
      Message: 'Invalid Request or Pet Type not found.',
      status: :unprocessable_entity
    }
  end
  end
end
end

def get_items_by_item_category
  respond_to do |format|
  if (!params[:pet_type_id].nil? and ItemCategory.where(:id => params[:id], :IsHaveBrand => false).exists?)
    if (!params[:pageno].nil? and !params[:size].nil?)
      size = params[:size].to_i
      page = params[:pageno].to_i
      brand =  Item.left_outer_joins(:item_categories, :pet_types).where(item_categories: { id: params[:id] }).where(pet_types: { id: params[:pet_type_id] }).limit(size).offset(page * size)
    else
      brand =  Item.left_outer_joins(:item_categories, :pet_types).where(item_categories: { id: params[:id] }).where(pet_types: { id: params[:pet_type_id] })
    end

  json_to_render = []
  @items = brand.where(:is_active => true)
  if @items.nil? or @items.empty?
    format.json do
      render json: {
        Message: 'No Items found'
      }
    end
  else
  @items.each do |myitem|
    json_to_render << ({
      :item => myitem.as_json(:only => [:id, :picture, :name, :price, :unit_price, :discount, :description, :weight, :unit, :rating, :review_count, :avg_rating, :quantity, :short_description]),
      :IsFavorite => get_wish_list_flag(myitem),
      :WishlistId => get_wish_list_id(myitem)
      }
    )
    end
    format.json do
  render :json => json_to_render
end
end
else
format.json do
  render json: {
    Message: 'Invalid Request or Category not found.',
    status: :unprocessable_entity
  }
end
end
end
end
  # GET /items/1
  # GET /items/1.json
  def show
    render json: {
      :Item => @item,
      :IsFavorite => get_wish_list_flag(@item),
      :WishlistId => get_wish_list_id(@item)
      }
  end

  def item_by_brand_id
    respond_to do |format|
    if (!params[:pet_type_id].nil? and !params[:category_id].nil? and !params[:id].nil?)
    json_to_render = []

    if (!params[:pageno].nil? and !params[:size].nil?)
      size = params[:size].to_i
      page = params[:pageno].to_i
      @items = Item.left_outer_joins(:item_categories, :pet_types).where(item_categories: { id: params[:category_id] }).where(pet_types: { id: params[:pet_type_id] }).where(:item_brand_id => params[:id]).limit(size).offset(page * size)
    else
      @items = Item.left_outer_joins(:item_categories, :pet_types).where(item_categories: { id: params[:category_id] }).where(pet_types: { id: params[:pet_type_id] }).where(:item_brand_id => params[:id])
    end
    @items = @items.where(:is_active => true)
    if @items.nil? or @items.empty?
      format.json do
        render json: {
          Message: 'No Items found'
        }
      end
    else
    @items.each do |myitem|
      json_to_render << ({
        :item => myitem.as_json(:only => [:id, :picture, :name, :price, :unit_price, :discount, :description, :weight, :unit, :rating, :review_count, :avg_rating, :quantity, :short_description]),
        :IsFavorite => get_wish_list_flag(myitem),
        :WishlistId => get_wish_list_id(myitem)
        }
      )
      end
      format.json do
    render :json => json_to_render
  end
end
  else
    format.json do
      render json: {
        Message: 'Invalid Request. Brand not found',
        status: :unprocessable_entity
      }
    end
  end
end
  end
  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find_by_id(params[:id])
      return render_404 unless @item
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:name, :price, :discount, :weight, :unit)
    end

    def get_wish_list_flag(item)
      if Wishlist.where(:user_id => @user.id, :item_id => item.id).exists?
        true
      else
        false
      end
    end
    def get_wish_list_id(item)
      if Wishlist.where(:user_id => @user.id, :item_id => item.id).exists?
        founditem = Wishlist.where(:user_id => @user.id, :item_id => item.id).first
        founditem.id
      else
        0
      end
    end
end
end
end
