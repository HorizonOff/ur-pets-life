module AdminPanel
  class ItemCategoriesController < AdminPanelController
  before_action :authorize_super_admin_employee, only: :index
  before_action :set_admin_panel_item_category, only: [:show, :edit, :update, :destroy]

  # GET /admin_panel/item_categories
  # GET /admin_panel/item_categories.json
  def index
    respond_to do |format|
      format.html {}
      format.json { filter_categories }
    end
  end

  # GET /admin_panel/item_categories/1
  # GET /admin_panel/item_categories/1.json
  def show
  end

  # GET /admin_panel/item_categories/new
  def new
    @admin_panel_item_category = ItemCategory.new
  end

  # GET /admin_panel/item_categories/1/edit
  def edit
  end

  # POST /admin_panel/item_categories
  # POST /admin_panel/item_categories.json
  def create
    @admin_panel_item_category = ItemCategory.new(admin_panel_item_category_params)

    if @admin_panel_item_category.save
      flash[:success] = 'Item Category was successfully created'
      redirect_to admin_panel_item_categories_path
    else
      render :new
    end

  end

  # PATCH/PUT /admin_panel/item_categories/1
  # PATCH/PUT /admin_panel/item_categories/1.json
  def update
    if @admin_panel_item_category.update(admin_panel_item_category_params)
      flash[:success] = 'Item Category was successfully updated'
      redirect_to admin_panel_item_categories_path
    else
      render :edit
    end
  end

  # DELETE /admin_panel/item_categories/1
  # DELETE /admin_panel/item_categories/1.json
  def destroy
    @admin_panel_item_category.destroy
    respond_to do |format|
      format.html { redirect_to admin_panel_item_categories_url, notice: 'Item category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_panel_item_category
      @admin_panel_item_category = ItemCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_panel_item_category_params
      params.require(:item_category).permit(:name, :IsHaveBrand, :picture, :avatar_cache, pet_type_ids: [])
    end

    def filter_categories
      filtered_categories = filter_and_pagination_query.filter
      decorated_data = ::AdminPanel::ItemCategoryDecorator.decorate_collection(filtered_categories)
      serialized_data = ActiveModel::Serializer::CollectionSerializer.new(
        decorated_data, serializer: ::AdminPanel::ItemCategorySerializer, adapter: :attributes
      )

      render json: { draw: params[:draw], recordsTotal: filtered_categories.count,
                     recordsFiltered: filtered_categories.total_count, data: serialized_data }
    end

    def filter_and_pagination_query
      @filter_and_pagination_query ||= ::AdminPanel::FilterAndPaginationQuery.new('ItemCategory', params)
    end

end
end
