module AdminPanel
class PettypesController < AdminPanelController
  before_action :authorize_super_admin, only: :index
  before_action :set_admin_panel_pettype, only: [:show, :edit, :update, :destroy]

  # GET /admin_panel/pettypes
  # GET /admin_panel/pettypes.json
  def index
    respond_to do |format|
      format.html {}
      format.json { filter_pettypes }
    end
  end

  # GET /admin_panel/pettypes/1
  # GET /admin_panel/pettypes/1.json
  def show
  end

  # GET /admin_panel/pettypes/new
  def new
    @admin_panel_pettype = PetType.new
  end

  # GET /admin_panel/pettypes/1/edit
  def edit
  end

  # POST /admin_panel/pettypes
  # POST /admin_panel/pettypes.json
  def create
    @admin_panel_pettype = PetType.new(admin_panel_pettype_params)

    respond_to do |format|
      if @admin_panel_pettype.save
        format.html { redirect_to @admin_panel_pettype, notice: 'Pettype was successfully created.' }
        format.json { render :show, status: :created, location: @admin_panel_pettype }
      else
        format.html { render :new }
        format.json { render json: @admin_panel_pettype.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin_panel/pettypes/1
  # PATCH/PUT /admin_panel/pettypes/1.json
  def update
    respond_to do |format|
      if @admin_panel_pettype.update(admin_panel_pettype_params)
        format.html { redirect_to @admin_panel_pettype, notice: 'Pettype was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_panel_pettype }
      else
        format.html { render :edit }
        format.json { render json: @admin_panel_pettype.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_panel/pettypes/1
  # DELETE /admin_panel/pettypes/1.json
  def destroy
    @admin_panel_pettype.destroy
    respond_to do |format|
      format.html { redirect_to admin_panel_pettypes_url, notice: 'Pettype was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_panel_pettype
      @admin_panel_pettype = PetType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_panel_pettype_params
      params.fetch(:admin_panel_pettype, {})
    end

    def filter_pettypes
      filtered_pet_types = filter_and_pagination_query.filter
      decorated_data = ::AdminPanel::PettypeDecorator.decorate_collection(filtered_pet_types)
      serialized_data = ActiveModel::Serializer::CollectionSerializer.new(
        decorated_data, serializer: ::AdminPanel::PettypeSerializer, adapter: :attributes
      )

      render json: { draw: params[:draw], recordsTotal: filtered_pet_types.count,
                     recordsFiltered: filtered_pet_types.total_count, data: serialized_data }
    end

    def filter_and_pagination_query
      @filter_and_pagination_query ||= ::AdminPanel::FilterAndPaginationQuery.new('PetType', params)
    end

end
end
